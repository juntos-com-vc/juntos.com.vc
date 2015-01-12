class Page < ActiveRecord::Base
  include Shared::CatarseAutoHtml

  validates_presence_of :content
  enum name: [:who_we_are, :mission, :vision, :values, :goals]

  catarse_auto_html_for field: :content, video_width: 600, video_height: 403

end
