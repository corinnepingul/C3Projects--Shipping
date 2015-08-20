class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :request
      t.string :delivery_method_chosen

      t.timestamps null: false
    end
  end
end
