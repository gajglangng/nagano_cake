class Order < ApplicationRecord
  
  #def with_tax_price
  #  (price * 1.1).floor
  #end
  
  validates :order_status, presence: true
  validates :customer_id, :address, :name, :postage,
			  		:total_payment, :payment_method,
			  		presence: true
	#validates :postal_code, length: {is: 7}, numericality: { only_integer: true }
	validates :postage, :total_payment, numericality: { only_integer: true }		  		
	
	#validates :price, presence: true,
   #                 numericality: { only_integer: true,
    #                                greater_than_or_equal_to: 0
     #                             }
  
  belongs_to :customer
  has_many :cart_items, through: :order_details
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
