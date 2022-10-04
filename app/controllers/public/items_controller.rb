class Public::ItemsController < ApplicationController
  def index
    @customer = current_customer
        
    #ページネーション
    @pages = @items.all.page(params[:page])
  end

  
end
