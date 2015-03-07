class AddPartnerIndicationToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :partner_indication, :boolean, default: false
  end
end
