module Shared::CatarseAutoHtml
  extend ActiveSupport::Concern

  included do
    AutoHtml.add_filter(:email_image).with(width: 200) do |text, options|
      text.gsub(/http(s)?:\/\/.+\.(jpg|jpeg|bmp|gif|png)(\?\S+)?/i) do |match|
        width = options[:width]
        %|<img src="#{match}" alt="" style="max-width:#{width}px" />|
      end
    end

    AutoHtml.add_filter(:add_alt_link_class) do |text, options|
      text.gsub(/<a/i, '<a class="alt-link"')
    end

    AutoHtml.add_filter(:add_link_alias) do |text, options|
      text.gsub(/&quot;.+&quot;:<a.+<\/a>/i) do |match|
        ali = match.to_s.split("&quot;")[1]
        link = match.to_s.gsub(/"_blank">.+<\/a>/, "\"_blank\">#{ali}</a>")
        link_with_alias = link.match(/<a.*a>/).to_s
        link_with_alias
      end
    end

    def self.catarse_auto_html_for options={}
      self.auto_html_for options[:field] do
        html_escape map: {
          '&' => '&amp;',
          '>' => '&gt;',
          '<' => '&lt;',
          '"' => '"'
        }
        image
        youtube width: options[:video_width], height: options[:video_height], wmode: "opaque"
        vimeo width: options[:video_width], height: options[:video_height]
        redcarpet target: :_blank
        link target: :_blank
        add_alt_link_class
        add_link_alias
      end
    end

    def catarse_email_auto_html_for field_data, options= {}
      self.auto_html field_data do
        html_escape map: {
          '&' => '&amp;',
          '>' => '&gt;',
          '<' => '&lt;',
          '"' => '"'
        }
        email_image width: options[:image_width]
        redcarpet target: :_blank
        link target: :_blank
      end
    end
  end
end
