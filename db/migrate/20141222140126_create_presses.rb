class CreatePresses < ActiveRecord::Migration
  def change
    create_table :presses do |t|
      t.string :title
      t.string :medium
      t.date :published_at
      t.text :quote

      t.timestamps
    end
  end
end
