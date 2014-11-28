class CreateProjectPartners < ActiveRecord::Migration
  def change
    create_table :project_partners do |t|
      t.string :image
      t.string :link
      t.references :project, index: true

      t.timestamps
    end
  end
end
