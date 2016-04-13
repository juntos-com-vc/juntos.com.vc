class AddCustomSubmitTextToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :custom_submit_text, :string
  end
end
