class AddOrderIdAndDeliveryMethodToShippingOrder < ActiveRecord::Migration
  def change
    add_column :shipping_orders, :order_id, :integer
    add_column :shipping_orders, :delivery_method, :string
  end
end
