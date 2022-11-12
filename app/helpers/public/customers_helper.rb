module Public::CustomersHelper
  
  def subtotal(cart_item)
    cart_item.item.tax_in_price * cart_item.amount
  end
  
  
  
end
