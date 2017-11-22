# frozen_string_literal: true

module Admin
  class RolesController < BaseController
    before_action :set_user

    def promote
      authorize @user, :promote?
      @user.promote!
      redirect_to admin_account_path(@user.account_id)
    end

    def demote
      authorize @user, :demote?
      @user.demote!
      redirect_to admin_account_path(@user.account_id)
    end

    private

    def set_user
      @user = Account.find(params[:account_id]).user || raise(ActiveRecord::RecordNotFound)
    end
  end
end
