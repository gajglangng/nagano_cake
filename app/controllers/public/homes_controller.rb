class Public::HomesController < ApplicationController
  def top
    @customer = current_customer
    # 新着商品
    @new_items = Item.find(OrderDetail.joins(:item).group('item_id').order('count(item_id) desc').limit(4).pluck(:item_id))
    
    #ジャンル検索
    @genres = Genre.where(is_valid: true)
    if @genre = Genre.find_by(name: params[:name])
       @items = @genre.items.page(params[:page]).reverse_order
    else
       @items = Item.page(params[:page]).reverse_order
    end
  end
  
  def about
    
  end
  
end 
