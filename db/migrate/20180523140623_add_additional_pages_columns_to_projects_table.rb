class AddAdditionalPagesColumnsToProjectsTable < ActiveRecord::Migration
  def change
    add_column :projects, :page1, :text, :null => true
    add_column :projects, :page1_title, :string, :null => true
    add_column :projects, :page2, :text, :null => true
    add_column :projects, :page2_title, :string, :null => true
  end
end
