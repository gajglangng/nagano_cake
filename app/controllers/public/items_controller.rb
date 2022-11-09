class Public::ItemsController < ApplicationController
  def index
    
    #@items = Item.find(OrderDetail.joins(:item).group('item_id').order('count(item_id) desc').limit(8).pluck(:item_id))
    @customer = current_customer
    @items = Item.page(params[:page]).per(8)
    
    #@item = Item.find(params[:id])
    #ジャンル検索
    @genres = Genre.where(is_valid: true)
     #if @genre = Genre.find_by(name: params[:name])
      #  @items = @genre.items.where(is_active: true).page(params[:page]).reverse_order
     #else
	    #  @items = Item.where(is_active: true).where(genre_id: @genres).page(params[:page]).reverse_order
     #end
    #ページネーション
    @pages = Item.page(params[:page])
    
  end
  


  def show
    @customer = current_customer
    @item = Item.find(params[:id])
    @genres = Genre.where(is_valid: true)
    #@cart_item =CartItem
  end
  
  private
    def item_params
      params.require(:items).permit(:genre_id, :name, :introduction, :image_id, :price)
    end
  
end
