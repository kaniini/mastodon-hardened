# frozen_string_literal: true
# == Schema Information
#
# Table name: list_accounts
#
#  id         :integer          not null, primary key
#  list_id    :integer          not null
#  account_id :integer          not null
#  follow_id  :integer          not null
#

class ListAccount < ApplicationRecord
  belongs_to :list, required: true
  belongs_to :account, required: true
  belongs_to :follow, required: true

  before_validation :set_follow

  private

  def set_follow
    self.follow = Follow.find_by(account_id: list.account_id, target_account_id: account.id)
  end
end
