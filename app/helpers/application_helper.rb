module ApplicationHelper

 def current_cart
  @cart_items = current_customer.cart_items
 end

 # 小計の計算
 #def sub_price(sub)
 # sub.item.with_tax_price * sub.amount
 #end

 def subtotal(cart_item)
  cart_item.item.with_tax_price * cart_item.amount
 end

 # 合計金額の計算
 #def total_price(totals)
 #price = 0
 #totals.each do |total|
 # price  +=  sub_price(total)
 #end
 # return price
 #end
 
 def total_price(cart_items)
  total_price = 0
  cart_items.each do |cart_item|
   total_price += subtotal(cart_item)
  end
   return total_price
 end  


 def billing(order)
  total_price(current_cart) + order.postage
 end

end