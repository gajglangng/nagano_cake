class Order < ApplicationRecord
  
  
  validates :total_payment, presence: true
  validates :payment_method, presence: true
  validates :postage, presence: true
  #validates :ship.address, length: { in: 1..48 }
  #validates :ship.postal_code, format: { with: VALID_POSTCODE_REGEX }
  #validates :ship.name, length: { in: 1..32 }
  validates :order_status, presence: true
  
  belongs_to :customer
  has_many :cart_items
  has_many :order_details, dependent: :destroy
  #has_many :items, through: :ordered_items  #注文には商品が多くある


  enum payment_method: { 
    クレジットカード: 0, 
    銀行振込: 1
    }
    
  enum order_status:{
    waiting: 0,
    paid_up: 1,
    making: 2,
    preparing: 3,
    shipped: 4
  }
end
