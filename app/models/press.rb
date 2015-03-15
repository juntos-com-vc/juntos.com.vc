class Press < ActiveRecord::Base
  default_scope  { order('published_at desc')}
  validates :title, :quote, :link, :medium, :published_at, presence: true
end
