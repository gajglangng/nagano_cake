class Public::CartItemsController < ApplicationController
  
  before_action :authenticate_customer!

  def cart
    @customer = current_customer
    @cart_items = CartItem.where(customer_id: current_customer.id)
    #@cart_item = CartItem.all
  end

  def create
    #binding.pry
    #@cart_item = CartItem.find(params[:item_id])
    @cart_item = current_customer.cart_items.new(cart_item_params)
    @cart_item.save
    
    if (CartItem.where(item_id: params[:item_id]).where(customer_id: current_customer.id).exists?) && (@amount.present?)
      @cart_item = CartItem.find_by(item_id: params[:item_id],customer_id: current_customer.id)
      @cart_item.amount += @amount.to_i
      @cart_item.save
       redirect_to cart_items_path
    elsif @cart_item.save
       redirect_to cart_items_path
    else
      @item = Item.find(params[:item_id])
      render "public/items/show"
    end
    
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(cart_item_params)
    redirect_to cart_items_path
  end

  def destroy
    #binding.pry
    cart_item = CartItem.find(params[:id])
    cart_item.destroy
    redirect_to cart_items_path
  end


  def destroy_all
    @Cart_item.destroy_all
    current_customer.cart_items.destroy_all
    redirect_to cart_items_path, notice: 'カートが空になりました。' 
  end

  

private
 
  def cart_item_params
    params.require(:cart_item).permit(:item_id, :amount, :customer_id)
  end
end
