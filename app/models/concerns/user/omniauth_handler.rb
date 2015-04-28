module User::OmniauthHandler
  extend ActiveSupport::Concern

  included do
    has_many :oauth_providers, through: :authorizations

    def self.create_from_hash(hash)
      name, email, bio = parse_name_email_bio(hash)
      create!(
        {
          name: name,
          email: email,
          bio: bio,
          locale: I18n.locale.to_s,
          image_url: "https://graph.facebook.com/#{hash['uid']}/picture?type=large"
        }
      )
    end

    def has_facebook_authentication?
      oauth = OauthProvider.find_by_name 'facebook'
      authorizations.where(oauth_provider_id: oauth.id).present? if oauth
    end

    def facebook_id
      auth = authorizations.joins(:oauth_provider).where("oauth_providers.name = 'facebook'").first
      auth.uid if auth
    end

    def self.parse_name_email_bio(hash)
      name = hash['info']['name'].encode('iso-8859-1').force_encoding('utf-8')
      unless name.valid_encoding?
        name = hash['info']['name']
      end
      email = hash['info']['email'].encode('iso-8859-1').force_encoding('utf-8')
      unless email.valid_encoding?
        email = hash['info']['email']
      end
      bio = if text = hash['info']['description']
              text = text[0..139].encode('iso-8859-1').force_encoding('utf-8')
              if text.valid_encoding?
                text
              else
                hash['info']['description']
              end
            else
              nil
            end
      [name, email, bio]
    end
  end
end

