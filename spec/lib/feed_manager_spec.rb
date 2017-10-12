require 'rails_helper'

RSpec.describe FeedManager do
  it 'tracks at least as many statuses as reblogs' do
    expect(FeedManager::REBLOG_FALLOFF).to be <= FeedManager::MAX_ITEMS
  end

  describe '#key' do
    subject { FeedManager.instance.key(:home, 1) }

    it 'returns a string' do
      expect(subject).to be_a String
    end
  end

  describe '#filter?' do
    let(:alice) { Fabricate(:account, username: 'alice') }
    let(:bob)   { Fabricate(:account, username: 'bob', domain: 'example.com') }
    let(:jeff)  { Fabricate(:account, username: 'jeff') }

    context 'for home feed' do
      it 'returns false for followee\'s status' do
        status = Fabricate(:status, text: 'Hello world', account: alice)
        bob.follow!(alice)
        expect(FeedManager.instance.filter?(:home, status, bob.id)).to be false
      end

      it 'returns false for reblog by followee' do
        status = Fabricate(:status, text: 'Hello world', account: jeff)
        reblog = Fabricate(:status, reblog: status, account: alice)
        bob.follow!(alice)
        expect(FeedManager.instance.filter?(:home, reblog, bob.id)).to be false
      end

      it 'returns true for reblog by followee of blocked account' do
        status = Fabricate(:status, text: 'Hello world', account: jeff)
        reblog = Fabricate(:status, reblog: status, account: alice)
        bob.follow!(alice)
        bob.block!(jeff)
        expect(FeedManager.instance.filter?(:home, reblog, bob.id)).to be true
      end

      it 'returns true for reblog by followee of muted account' do
        status = Fabricate(:status, text: 'Hello world', account: jeff)
        reblog = Fabricate(:status, reblog: status, account: alice)
        bob.follow!(alice)
        bob.mute!(jeff)
        expect(FeedManager.instance.filter?(:home, reblog, bob.id)).to be true
      end

      it 'returns true for reblog by followee of someone who is blocking recipient' do
        status = Fabricate(:status, text: 'Hello world', account: jeff)
        reblog = Fabricate(:status, reblog: status, account: alice)
        bob.follow!(alice)
        jeff.block!(bob)
        expect(FeedManager.instance.filter?(:home, reblog, bob.id)).to be true
      end

      it 'returns false for reply by followee to another followee' do
        status = Fabricate(:status, text: 'Hello world', account: jeff)
        reply  = Fabricate(:status, text: 'Nay', thread: status, account: alice)
        bob.follow!(alice)
        bob.follow!(jeff)
        expect(FeedManager.instance.filter?(:home, reply, bob.id)).to be false
      end

      it 'returns false for reply by followee to recipient' do
        status = Fabricate(:status, text: 'Hello world', account: bob)
        reply  = Fabricate(:status, text: 'Nay', thread: status, account: alice)
        bob.follow!(alice)
        expect(FeedManager.instance.filter?(:home, reply, bob.id)).to be false
      end

      it 'returns false for reply by followee to self' do
        status = Fabricate(:status, text: 'Hello world', account: alice)
        reply  = Fabricate(:status, text: 'Nay', thread: status, account: alice)
        bob.follow!(alice)
        expect(FeedManager.instance.filter?(:home, reply, bob.id)).to be false
      end

      it 'returns true for reply by followee to non-followed account' do
        status = Fabricate(:status, text: 'Hello world', account: jeff)
        reply  = Fabricate(:status, text: 'Nay', thread: status, account: alice)
        bob.follow!(alice)
        expect(FeedManager.instance.filter?(:home, reply, bob.id)).to be true
      end

      it 'returns true for the second reply by followee to a non-federated status' do
        reply        = Fabricate(:status, text: 'Reply 1', reply: true, account: alice)
        second_reply = Fabricate(:status, text: 'Reply 2', thread: reply, account: alice)
        bob.follow!(alice)
        expect(FeedManager.instance.filter?(:home, second_reply, bob.id)).to be true
      end

      it 'returns false for status by followee mentioning another account' do
        bob.follow!(alice)
        status = PostStatusService.new.call(alice, 'Hey @jeff')
        expect(FeedManager.instance.filter?(:home, status, bob.id)).to be false
      end

      it 'returns true for status by followee mentioning blocked account' do
        bob.block!(jeff)
        bob.follow!(alice)
        status = PostStatusService.new.call(alice, 'Hey @jeff')
        expect(FeedManager.instance.filter?(:home, status, bob.id)).to be true
      end

      it 'returns true for reblog of a personally blocked domain' do
        alice.block_domain!('example.com')
        alice.follow!(jeff)
        status = Fabricate(:status, text: 'Hello world', account: bob)
        reblog = Fabricate(:status, reblog: status, account: jeff)
        expect(FeedManager.instance.filter?(:home, reblog, alice.id)).to be true
      end
    end

    context 'for mentions feed' do
      it 'returns true for status that mentions blocked account' do
        bob.block!(jeff)
        status = PostStatusService.new.call(alice, 'Hey @jeff')
        expect(FeedManager.instance.filter?(:mentions, status, bob.id)).to be true
      end

      it 'returns true for status that replies to a blocked account' do
        status = Fabricate(:status, text: 'Hello world', account: jeff)
        reply  = Fabricate(:status, text: 'Nay', thread: status, account: alice)
        bob.block!(jeff)
        expect(FeedManager.instance.filter?(:mentions, reply, bob.id)).to be true
      end

      it 'returns true for status by silenced account who recipient is not following' do
        status = Fabricate(:status, text: 'Hello world', account: alice)
        alice.update(silenced: true)
        expect(FeedManager.instance.filter?(:mentions, status, bob.id)).to be true
      end

      it 'returns false for status by followed silenced account' do
        status = Fabricate(:status, text: 'Hello world', account: alice)
        alice.update(silenced: true)
        bob.follow!(alice)
        expect(FeedManager.instance.filter?(:mentions, status, bob.id)).to be false
      end
    end
  end

  describe '#push' do
    it 'trims timelines if they will have more than FeedManager::MAX_ITEMS' do
      account = Fabricate(:account)
      status = Fabricate(:status)
      members = FeedManager::MAX_ITEMS.times.map { |count| [count, count] }
      Redis.current.zadd("feed:type:#{account.id}", members)

      FeedManager.instance.push('type', account, status)

      expect(Redis.current.zcard("feed:type:#{account.id}")).to eq FeedManager::MAX_ITEMS
    end

    it 'sends push updates for non-home timelines' do
      account = Fabricate(:account)
      status = Fabricate(:status)
      allow(Redis.current).to receive_messages(publish: nil)

      FeedManager.instance.push('type', account, status)

      expect(Redis.current).to have_received(:publish).with("timeline:#{account.id}", any_args).at_least(:once)
    end

    context 'reblogs' do
      it 'saves reblogs of unseen statuses' do
        account = Fabricate(:account)
        reblogged = Fabricate(:status)
        reblog = Fabricate(:status, reblog: reblogged)

        expect(FeedManager.instance.push('type', account, reblog)).to be true
      end

      it 'does not save a new reblog of a recent status' do
        account = Fabricate(:account)
        reblogged = Fabricate(:status)
        reblog = Fabricate(:status, reblog: reblogged)

        FeedManager.instance.push('type', account, reblogged)

        expect(FeedManager.instance.push('type', account, reblog)).to be false
      end

      it 'saves a new reblog of an old status' do
        account = Fabricate(:account)
        reblogged = Fabricate(:status)
        reblog = Fabricate(:status, reblog: reblogged)

        FeedManager.instance.push('type', account, reblogged)

        # Fill the feed with intervening statuses
        FeedManager::REBLOG_FALLOFF.times do
          FeedManager.instance.push('type', account, Fabricate(:status))
        end

        expect(FeedManager.instance.push('type', account, reblog)).to be true
      end

      it 'does not save a new reblog of a recently-reblogged status' do
        account = Fabricate(:account)
        reblogged = Fabricate(:status)
        reblogs = 2.times.map { Fabricate(:status, reblog: reblogged) }

        # The first reblog will be accepted
        FeedManager.instance.push('type', account, reblogs.first)

        # The second reblog should be ignored
        expect(FeedManager.instance.push('type', account, reblogs.last)).to be false
      end

      it 'saves a new reblog of a long-ago-reblogged status' do
        account = Fabricate(:account)
        reblogged = Fabricate(:status)
        reblogs = 2.times.map { Fabricate(:status, reblog: reblogged) }

        # The first reblog will be accepted
        FeedManager.instance.push('type', account, reblogs.first)

        # Fill the feed with intervening statuses
        FeedManager::REBLOG_FALLOFF.times do
          FeedManager.instance.push('type', account, Fabricate(:status))
        end

        # The second reblog should also be accepted
        expect(FeedManager.instance.push('type', account, reblogs.last)).to be true
      end
    end
  end

  describe '#unpush' do
    it 'leaves a reblogged status when deleting the reblog' do
      account = Fabricate(:account)
      reblogged = Fabricate(:status)
      status = Fabricate(:status, reblog: reblogged)

      FeedManager.instance.push('type', account, status)

      # The reblogging status should show up under normal conditions.
      expect(Redis.current.zrange("feed:type:#{account.id}", 0, -1)).to eq [status.id.to_s]

      FeedManager.instance.unpush('type', account, status)

      # Because we couldn't tell if the status showed up any other way,
      # we had to stick the reblogged status in by itself.
      expect(Redis.current.zrange("feed:type:#{account.id}", 0, -1)).to eq [reblogged.id.to_s]
    end

    it 'sends push updates' do
      account = Fabricate(:account)
      status = Fabricate(:status)
      FeedManager.instance.push('type', account, status)

      allow(Redis.current).to receive_messages(publish: nil)
      FeedManager.instance.unpush('type', account, status)

      deletion = Oj.dump(event: :delete, payload: status.id.to_s)
      expect(Redis.current).to have_received(:publish).with("timeline:#{account.id}", deletion)
    end
  end
end
