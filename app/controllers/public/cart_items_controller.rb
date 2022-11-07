class Public::CartItemsController < ApplicationController
  
  before_action :authenticate_customer!

  def cart
    @customer = current_customer
    @cart_items = CartItem.where(customer_id: current_customer.id)
    @price = 0
    @cart_items.each do |cart_item|
      
      @price += cart_item.subtotal
    end
  end

  def create
    #@amount = params[:amount] ? params[:amount] : params[:cart_item][:amount]
    @cart_item = CartItem.new(cart_item_params)
    #@item = Item.find(cart_item_params)
    
    #@cart_item.customer_id = current_customer.id
    #if @cart_item.save
    #  redirect_to action: :cart
    #else
      #@item = Item.find(params[:item_id])
      @genres = Genre.where(is_valid: true)
      #render "public/items/show"
    #end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    if @cart_item.update(cart_item_count_params)
        redirect_to action: :cart
    else
      redirect_to action: :cart
    end
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to action: :cart
  end

  def destroy_all
    CartItem.where(customer_id: current_customer.id).destroy_all
    redirect_to action: :cart
  end


private
 
  def cart_item_params
    params.permit(:amount)
  end
end
