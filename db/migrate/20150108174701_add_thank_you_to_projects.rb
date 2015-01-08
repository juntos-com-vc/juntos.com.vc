class AddThankYouToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :thank_you, :text
  end
end
