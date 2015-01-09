class CreateChannelImages < ActiveRecord::Migration
  def change
    create_table :channel_images do |t|
      t.string :image
      t.references :channel, index: true
      t.timestamps
    end
  end
end
