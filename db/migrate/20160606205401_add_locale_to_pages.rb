class AddLocaleToPages < ActiveRecord::Migration
  def up
    add_column :pages, :locale, :string
  end

  def down
    remove_column :pages, :locale
  end
end
