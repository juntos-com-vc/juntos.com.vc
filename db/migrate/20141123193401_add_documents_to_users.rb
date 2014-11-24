class AddDocumentsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :doc1, :string
    add_column :users, :doc2, :string
    add_column :users, :doc3, :string
    add_column :users, :doc4, :string
    add_column :users, :doc5, :string
    add_column :users, :doc6, :string
    add_column :users, :doc7, :string
    add_column :users, :doc8, :string
    add_column :users, :doc9, :string
    add_column :users, :doc10, :string
    add_column :users, :doc11, :string
    add_column :users, :doc12, :string
    add_column :users, :doc13, :string
    add_column :users, :doc_updated_at, :datetime
  end
end
