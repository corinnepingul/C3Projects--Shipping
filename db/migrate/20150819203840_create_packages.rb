class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.integer :order_id
      t.integer :weight
      t.integer :length
      t.integer :width

      t.timestamps null: false
    end
  end
end
