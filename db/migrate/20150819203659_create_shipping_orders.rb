class CreateShippingOrders < ActiveRecord::Migration
  def change
    create_table :shipping_orders do |t|
      t.string :origin_country
      t.string :origin_state
      t.string :origin_city
      t.string :origin_zip
      t.string :destination_country
      t.string :destination_state
      t.string :destination_city
      t.string :destination_zip

      t.timestamps null: false
    end
  end
end
