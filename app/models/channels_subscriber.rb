class ChannelsSubscriber < ActiveRecord::Base
  belongs_to :channel
  belongs_to :user

  validates_presence_of :user_id, :channel_id
end
