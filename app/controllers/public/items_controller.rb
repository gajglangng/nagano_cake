class Public::ItemsController < ApplicationController
  def index
    @customer = current_customer
        
    #ページネーション
    @pages = @items.all.page(params[:page])
  end

  def show
    @customer = current_customer
    @item = Item.find(params[:id])
  end
end
