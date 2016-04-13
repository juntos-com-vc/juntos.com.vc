class ChannelDecorator < Draper::Decorator
  decorates :channel

  def display_facebook
    last_fragment(source.facebook)
  end

  def display_twitter
    "@#{last_fragment(source.twitter)}"
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

  private
  def last_fragment(uri)
    uri.split("/").last
  end
end
