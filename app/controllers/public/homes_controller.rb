class Public::HomesController < ApplicationController
  def top
    @customer = current_customer
    # 新着商品
    @new_items = Item.find(OrderDetail.joins(:item).group('item_id').order('count(item_id) desc').limit(4).pluck(:item_id))
  end
  
  def about
    
  end
  
end 
