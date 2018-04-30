class AddAdditionalPagesColumnsToChannelsTable < ActiveRecord::Migration
  def change
    add_column :channels, :page1, :text, :null => true
    add_column :channels, :page2, :text, :null => true
    add_column :channels, :page3, :text, :null => true
    add_column :channels, :page4, :text, :null => true
  end
end
