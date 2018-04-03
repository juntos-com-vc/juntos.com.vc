class AddTicketPriceToProjectsTable < ActiveRecord::Migration
  def change
    add_column :projects, :ticket_price, :decimal, :null => true
  end
end
