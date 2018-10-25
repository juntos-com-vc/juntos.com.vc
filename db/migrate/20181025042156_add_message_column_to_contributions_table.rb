class AddMessageColumnToContributionsTable < ActiveRecord::Migration
  def change
    add_column :contributions, :message, :text, :null => true
  end
end
