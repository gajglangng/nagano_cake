class Public::CartItemsController < ApplicationController
  
  before_action :authenticate_customer!

  def cart
    @customer = current_customer
    @cart_items = current_customer.cart_items.all
    @price = 0
    
  end

  def create
    #@amount = params[:amount] ? params[:amount] : params[:cart_item][:amount]
    @cart_item = CartItem.new(params[:id])
    #@cart_item = CartItem.new({customer_id:params[:customer_id], item_id:params[:item_id], amount:@amount})
    #@item = Item.find(cart_item_params)
    
    @cart_item.customer_id = current_customer.id
    @cart_item.save
    redirect_to action: :cart
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
    @cart_items = CartItem.all
    redirect_to action: :cart
  end

  def destroy_all
    #CartItem.where(customer_id: current_customer.id).destroy_all
    cart_items = CartItem.all
    redirect_to action: :cart
  end


private
 
  def cart_item_params
    params.require(:cart_item).permit(:item_id, :amount)
  end
end
