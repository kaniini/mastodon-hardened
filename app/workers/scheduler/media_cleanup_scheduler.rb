# frozen_string_literal: true
require 'sidekiq-scheduler'

class Scheduler::MediaCleanupScheduler
  include Sidekiq::Worker

  def perform
    unattached_media.find_each(&:destroy)
  end

  private

  def unattached_media
    MediaAttachment.reorder(nil).unattached.where('created_at < ?', 1.day.ago)
  end
end
