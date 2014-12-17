class Page < ActiveRecord::Base

  validates_presence_of :content
  enum name: [:who_we_are]

end
