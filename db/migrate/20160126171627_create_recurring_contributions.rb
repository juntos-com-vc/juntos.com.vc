class CreateRecurringContributions < ActiveRecord::Migration
  def change
    create_table :recurring_contributions do |t|
      t.references :project, index: true
      t.references :user, index: true
      t.string :credit_card
      t.decimal :value, precision: 8, scale: 2

      t.timestamps
    end
  end
end
