class AddCountryToContribution < ActiveRecord::Migration
  def change
    add_column :contributions, :country_code, :string
  end
end
