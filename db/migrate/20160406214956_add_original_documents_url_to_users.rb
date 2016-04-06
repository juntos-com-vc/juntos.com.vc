class AddOriginalDocumentsUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :original_doc1_url, :string
    add_column :users, :original_doc2_url, :string
    add_column :users, :original_doc3_url, :string
    add_column :users, :original_doc4_url, :string
    add_column :users, :original_doc5_url, :string
    add_column :users, :original_doc6_url, :string
    add_column :users, :original_doc7_url, :string
    add_column :users, :original_doc8_url, :string
    add_column :users, :original_doc9_url, :string
    add_column :users, :original_doc10_url, :string
    add_column :users, :original_doc11_url, :string
    add_column :users, :original_doc12_url, :string
    add_column :users, :original_doc13_url, :string
  end
end
