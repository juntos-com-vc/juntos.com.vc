class AddLinkToPresses < ActiveRecord::Migration
  def change
    add_column :presses, :link, :string
  end
end
