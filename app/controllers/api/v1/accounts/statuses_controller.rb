# frozen_string_literal: true

class Api::V1::Accounts::StatusesController < Api::BaseController
  before_action -> { doorkeeper_authorize! :read }
  before_action :set_account
  after_action :insert_pagination_headers

  respond_to :json

  def index
    @statuses = load_statuses
    render json: @statuses, each_serializer: REST::StatusSerializer, relationships: StatusRelationshipsPresenter.new(@statuses, current_user&.account_id)
  end

  private

  def set_account
    @account = Account.find(params[:account_id])
  end

  def load_statuses
    cached_account_statuses
  end

  def cached_account_statuses
    cache_collection account_statuses, Status
  end

  def account_statuses
    default_statuses.tap do |statuses|
      statuses.merge!(only_media_scope) if params[:only_media]
      statuses.merge!(pinned_scope) if params[:pinned]
      statuses.merge!(no_replies_scope) if params[:exclude_replies]
    end
  end

  def default_statuses
    permitted_account_statuses.paginate_by_max_id(
      limit_param(DEFAULT_STATUSES_LIMIT),
      params[:max_id],
      params[:since_id]
    )
  end

  def permitted_account_statuses
    @account.statuses.permitted_for(@account, current_account)
  end

  def only_media_scope
    Status.where(id: account_media_status_ids)
  end

  def account_media_status_ids
    @account.media_attachments.attached.reorder(nil).select(:status_id).distinct
  end

  def pinned_scope
    @account.pinned_statuses
  end

  def no_replies_scope
    Status.without_replies
  end

  def pagination_params(core_params)
    params.permit(:limit, :only_media, :exclude_replies).merge(core_params)
  end

  def insert_pagination_headers
    set_pagination_headers(next_path, prev_path)
  end

  def next_path
    if records_continue?
      api_v1_account_statuses_url pagination_params(max_id: pagination_max_id)
    end
  end

  def prev_path
    unless @statuses.empty?
      api_v1_account_statuses_url pagination_params(since_id: pagination_since_id)
    end
  end

  def records_continue?
    @statuses.size == limit_param(DEFAULT_STATUSES_LIMIT)
  end

  def pagination_max_id
    @statuses.last.id
  end

  def pagination_since_id
    @statuses.first.id
  end
end
