class CreateOrderDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :order_details do |t|
      t.integer :order_id
      t.integer :item_id
      t.integer :price_including_tax
      t.integer :item_count
      t.integer :production_status, default: 0
      t.timestamps
    end
  end
end