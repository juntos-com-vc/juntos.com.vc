class AddUuidToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :uuid, :string
  end
end
