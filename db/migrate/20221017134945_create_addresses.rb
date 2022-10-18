class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.integer :customer_id
      t.string :address
      t.string :postal_code
      t.string :name
      t.timestamps
    end
  end
end
