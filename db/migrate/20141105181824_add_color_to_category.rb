class AddColorToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :color, :string, limit: 7, default: '#FE6327'
  end
end
