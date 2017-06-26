class CreateSummaries < ActiveRecord::Migration
  def change
    create_table :summaries do |t|
      t.references :project, index: true, null: true
      t.integer :total_projects, null: true
      t.integer :contributions
      t.decimal :total

      t.timestamps
    end
  end
end
