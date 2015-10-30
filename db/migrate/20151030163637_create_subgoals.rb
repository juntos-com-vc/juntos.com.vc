class CreateSubgoals < ActiveRecord::Migration
  def change
    create_table :subgoals do |t|
      t.references :project, index: true
      t.string :color
      t.decimal :value, precision: 8, scale: 2
      t.text :text

      t.timestamps
    end
  end
end
