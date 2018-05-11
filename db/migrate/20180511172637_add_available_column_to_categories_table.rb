class AddAvailableColumnToCategoriesTable < ActiveRecord::Migration
  def change
    add_column :categories, :available, :boolean, default: true
  end
end
