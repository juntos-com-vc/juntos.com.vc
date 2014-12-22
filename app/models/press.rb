class Press < ActiveRecord::Base
  validates :title, :quote, :link, :medium, :published_at, presence: true
end
