class CartItem < ApplicationRecord
  belongs_to :customer
  belongs_to :item

  validates :item_count, presence: {message: 'を選択してください'}, numericality: { only_integer: true, greater_than: 0}
  
  ## 小計を求めるメソッド
  def subtotal
    item.with_tax_price * amount
  end
end
