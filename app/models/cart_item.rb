class CartItem < ApplicationRecord
  ## 小計を求めるメソッド
  def subtotal
    item.with_tax_price * amount
  end
end
