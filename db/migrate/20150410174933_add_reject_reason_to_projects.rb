class AddRejectReasonToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :reject_reason, :text
  end
end
