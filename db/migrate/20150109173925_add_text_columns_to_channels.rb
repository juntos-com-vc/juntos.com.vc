class AddTextColumnsToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :terms, :text
    add_column :channels, :privacy, :text
    add_column :channels, :contacts, :text
    add_column :channels, :terms_html, :text
    add_column :channels, :privacy_html, :text
    add_column :channels, :contacts_html, :text
  end
end
