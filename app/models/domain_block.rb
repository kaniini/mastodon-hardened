# frozen_string_literal: true
# == Schema Information
#
# Table name: domain_blocks
#
#  domain       :string           default(""), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  severity     :integer          default("silence")
#  reject_media :boolean          default(FALSE), not null
#  id           :integer          not null, primary key
#

class DomainBlock < ApplicationRecord
  enum severity: [:silence, :suspend, :noop]

  attr_accessor :retroactive

  validates :domain, presence: true, uniqueness: true

  has_many :accounts, foreign_key: :domain, primary_key: :domain
  delegate :count, to: :accounts, prefix: true

  def self.blocked?(domain)
    where(domain: domain, severity: :suspend).exists?
  end

  before_validation :normalize_domain

  private

  def normalize_domain
    self.domain = TagManager.instance.normalize_domain(domain)
  end
end
