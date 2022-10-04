class Item < ApplicationRecord
  ## 消費税を求めるメソッド
  def with_tax_price
    (price * 1.1).floor
  end
  
  
  
end
