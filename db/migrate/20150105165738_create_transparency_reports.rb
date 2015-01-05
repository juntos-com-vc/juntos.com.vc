class CreateTransparencyReports < ActiveRecord::Migration
  def change
    create_table :transparency_reports do |t|
      t.text :attachment

      t.timestamps
    end
  end
end
