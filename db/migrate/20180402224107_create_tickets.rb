class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.references :project
      t.references :user
      t.string :ticket

      t.timestamps
    end
    add_index :tickets, :ticket, unique: true
  end
end
