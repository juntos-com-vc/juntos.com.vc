class AddContentHtmlToPages < ActiveRecord::Migration
  def change
    add_column :pages, :content_html, :text
  end
end
