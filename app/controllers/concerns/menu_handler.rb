module Concerns
  module MenuHandler
    extend ActiveSupport::Concern

    included do
      @@menu_items = {}
      cattr_accessor :menu_items

      def self.add_to_menu i18n_name, path
        menu I18n.t(i18n_name) => path
      end

      def self.menu menu
        self.menu_items.merge! menu
      end

      # Only admin can access
      add_to_menu "admin.contributions.index.menu",          :admin_contributions_path
      add_to_menu "admin.financials.index.menu",             :admin_financials_path
      add_to_menu "admin.statistics.index.menu",             :admin_statistics_path
      add_to_menu "admin.users.index.menu",                  :admin_users_path
      add_to_menu "admin.projects.index.menu",               :admin_projects_path
      add_to_menu "admin.categories.index.menu",             :admin_categories_path
      add_to_menu "admin.site_partners.index.menu",          :admin_site_partners_path
      add_to_menu "admin.channels.index.menu",               :admin_channels_path
      add_to_menu "admin.pages.index.menu",                  :admin_pages_path
      add_to_menu "admin.presses.index.menu",                :admin_presses_path
      add_to_menu 'activerecord.models.transparency_report', :admin_transparency_report_path

      # Admin and channel admin can access
      add_to_menu "channels.admin.followers_menu",  :channels_admin_followers_path
      add_to_menu 'channels.admin.posts_menu',      :channels_admin_posts_path
      add_to_menu 'channels.admin.partners_menu',   :channels_admin_partners_path
      add_to_menu 'channels.admin.images_menu',     :channels_admin_images_path
      add_to_menu 'channels.admin.profile_menu',    :edit_channels_profile_path

      def menu
        channel_admin_paths = [:admin_contributions_path, :admin_projects_path, :channels_admin_followers_path, :channels_admin_posts_path, :channels_admin_partners_path, :channels_admin_images_path, :edit_channels_profile_path]
        ApplicationController.menu_items.inject({}) do |memo, el|
          if current_user.admin? || (channel_admin_paths.include?(el.last) && channel && channel.users.find(current_user.id))
            memo.merge!(el.first => Rails.application.routes.url_helpers.send(el.last))
          end
          memo
        end
      end
    end

  end
end
