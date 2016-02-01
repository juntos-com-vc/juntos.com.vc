class ChangeCategoryFieldOnProjects < ActiveRecord::Migration
  def change
    change_column_null :projects, :category_id, true
  end
end
