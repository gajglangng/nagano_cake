class Public::ItemsController < ApplicationController
  def index
    @customer = current_customer
    @items = Item.all    
    #ジャンル検索
    @genres = Genre.where(is_valid: true)
     if @genre = Genre.find_by(name: params[:name])
        @items = @genre.items.where(is_active: true).page(params[:page]).reverse_order
     else
	      @items = Item.where(is_active: true).where(genre_id: @genres).page(params[:page]).reverse_order
     end
    #ページネーション
    @pages = Item.page(params[:page])
  end

  def show
    @customer = current_customer
    @item = Item.find(params[:id])
    @genres = Genre.where(is_valid: true)
  end
  
  
end
