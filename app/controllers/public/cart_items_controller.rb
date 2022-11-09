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
    redirect_to cart_items_path
    
    
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(cart_item_params)
    redirect_to cart_items_path
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    #@cart_items = CartItem.all
    redirect_to cart_items_path
  end


  def destroy_all
    @cart_items = current_customer.cart_items
    cart_items.destroy_all
    redirect_to cart_items_path
  end

  

private
 
  def cart_item_params
    params.require(:cart_item).permit(:item_id, :amount, :customer_id)
  end
end
