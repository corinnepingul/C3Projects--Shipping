class AddClientOrderIdToLog < ActiveRecord::Migration
  def change
    add_column :logs, :client_order_id, :integer
  end
end
