class CartItem < ApplicationRecord
  belongs_to :customer
  belongs_to :item
  #belongs_to :order

  validates :amount, presence: {message: 'を選択してください'}, numericality: { only_integer: true, greater_than: 0}
  
  has_one_attached :image
  
 # 小計を求めるメソッド
  def subtotal
    item.with_tax_price * amount
  end
  
# 合計金額の計算
  def total_price(cart_items)
    total_price = 0
    cart_items.each do |cart_item|
      total_price += subtotal(cart_item)
    end
    return total_price
  end
end
