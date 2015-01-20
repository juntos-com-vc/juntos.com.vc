class AddCategoryToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :category_id, :integer
  end
end
