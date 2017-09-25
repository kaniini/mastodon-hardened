# frozen_string_literal: true

class ActivityPub::UpdateSerializer < ActiveModel::Serializer
  attributes :id, :type, :actor

  has_one :object, serializer: ActivityPub::ActorSerializer

  def id
    [ActivityPub::TagManager.instance.uri_for(object), '#updates/', object.updated_at.to_i].join
  end

  def type
    'Update'
  end

  def actor
    ActivityPub::TagManager.instance.uri_for(object)
  end
end
