# frozen_string_literal: true

class Api::ActivityPub::ActivitiesController < Api::BaseController
  include Authorization

  # before_action :set_follow, only: [:show_follow]
  before_action :set_status, only: [:show_status]

  respond_to :activitystreams2

  # Show a status in AS2 format, as either an Announce (reblog) or a Create (post) activity.
  def show_status
    authorize @status, :show?

    if @status.reblog?
      render :show_status_announce
    else
      render :show_status_create
    end
  end

  private

  def set_status
    @status = Status.find(params[:id])
  end
end
