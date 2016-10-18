
class ChannelDecorator < Draper::Decorator
  decorates :channel
  delegate_all

  def display_facebook
    last_fragment(source.facebook)
  end

  def display_twitter
    "@#{last_fragment(source.twitter)}"
  end

  def statistics_background_color
    channel.main_color ? main_color : "#FEB84C"
  end

  def display_website
    source.website.gsub(/https?:\/\//i, '')
  end

  def submit_your_project_text
    if source.custom_submit_text.blank?
      I18n.t(:submit_your_project, scope: [:layouts, :header])
    else
      source.custom_submit_text
    end
  end

  def email_image
    if source.email_header_image.blank?
      source.image.url
    else
      source.email_header_image.url
    end
  end

  private
  def last_fragment(uri)
    uri.split("/").last
  end
end
