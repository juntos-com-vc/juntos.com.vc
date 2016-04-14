class Channel < ActiveRecord::Base
  include Shared::CatarseAutoHtml
  include Shared::VideoHandler

  has_many :posts, class_name: "ChannelPost"
  has_many :partners, class_name: "ChannelPartner"
  has_many :images, class_name: "ChannelImage"

  validates_presence_of :name, :description, :permalink
  validates_uniqueness_of :permalink

  validates_presence_of :category_id, unless: :recurring?

  has_and_belongs_to_many :projects, -> { order_status.most_recent_first }
  has_many :subscribers, class_name: 'User', through: :channels_subscribers, source: :user
  has_many :channels_subscribers
  has_many :subscriber_reports
  has_many :users
  belongs_to :category

  catarse_auto_html_for field: :how_it_works, video_width: 560, video_height: 340
  catarse_auto_html_for field: :terms, video_width: 560, video_height: 340
  catarse_auto_html_for field: :privacy, video_width: 560, video_height: 340
  catarse_auto_html_for field: :contacts, video_width: 560, video_height: 340
  catarse_auto_html_for field: :description, video_width: 560, video_height: 340

  delegate :display_facebook, :display_twitter, :display_website,
           :submit_your_project_text, to: :decorator

  mount_uploader :image, ProfileUploader
  mount_uploader :email_header_image, ProfileUploader

  scope :by_permalink, ->(p) { where("lower(channels.permalink) = lower(?)", p) }

  def self.find_by_permalink!(string)
    self.by_permalink(string).first!
  end

  def self.recurring (recurring)
    where(recurring: recurring)
  end

  def has_subscriber? user
    user && subscribers.where(id: user.id).first.present?
  end

  def curator
    users.first
  end

  def to_s
    self.name
  end

  def host_path
    [self.permalink, CatarseSettings[:host]].join('.')
  end

  # Links to channels should be their permalink
  def to_param; self.permalink end

  # Using decorators
  def decorator
    @decorator ||= ChannelDecorator.new(self)
  end
end
