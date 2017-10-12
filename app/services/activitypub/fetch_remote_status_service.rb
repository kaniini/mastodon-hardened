# frozen_string_literal: true

class ActivityPub::FetchRemoteStatusService < BaseService
  include JsonLdHelper

  # Should be called when uri has already been checked for locality
  def call(uri, id: true, prefetched_body: nil)
    @json = if prefetched_body.nil?
              fetch_resource(uri, id)
            else
              body_to_json(prefetched_body)
            end

    return unless supported_context? && expected_type?

    return if actor_id.nil? || !trustworthy_attribution?(@json['id'], actor_id)

    actor = ActivityPub::TagManager.instance.uri_to_resource(actor_id, Account)
    actor = ActivityPub::FetchRemoteAccountService.new.call(actor_id, id: true) if actor.nil?

    return if actor.suspended?

    ActivityPub::Activity.factory(activity_json, actor).perform
  end

  private

  def activity_json
    { 'type' => 'Create', 'actor' => actor_id, 'object' => @json }
  end

  def actor_id
    first_of_value(@json['attributedTo'])
  end

  def trustworthy_attribution?(uri, attributed_to)
    Addressable::URI.parse(uri).normalized_host.casecmp(Addressable::URI.parse(attributed_to).normalized_host).zero?
  end

  def supported_context?
    super(@json)
  end

  def expected_type?
    %w(Note Article).include? @json['type']
  end
end
