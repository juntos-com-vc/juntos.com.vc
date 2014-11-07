class CreateSitePartners < ActiveRecord::Migration
  def change
    create_table :site_partners do |t|
      t.text :name, null: false
      t.text :logo, null: false
      t.text :url, null: false

      t.timestamps
    end
  end
end
