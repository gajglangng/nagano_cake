class Public::CartItemsController < ApplicationController
  
  before_action :authenticate_customer!

  def cart
    @customer = current_customer
    @cart_items = CartItem.where(customer_id: current_customer.id)
    #@cart_item = CartItem.all
  end

  def create
    @amount = params[:amount] ? params[:amount] : params[:cart_item][:amount]
    @cart_item = CartItem.new({customer_id:params[:customer_id], item_id:params[:item_id], amount:@amount})
    # binding.pry
    if (CartItem.where(item_id: params[:item_id]).where(customer_id: current_customer.id).exists?) && (@amount.present?)
      @cart_item = CartItem.find_by(item_id: params[:item_id],customer_id: current_customer.id)
      @cart_item.amount += @amount.to_i
      @cart_item.save
      redirect_to "public/cart_items/cart"
    elsif @cart_item.save
      redirect_to "public/cart_items/cart"
    else
      @item = Item.find_by(params[:item_id])
      @genres = Genre.where(is_valid: true)
      render "public/cart_items/cart"
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    if @cart_item.update(cart_item_params)
        redirect_to cart_items_path
    else
      redirect_to cart_items_path
    end
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.destroy
    @cart_items = CartItem.all
      render 'cart'
  end


  def destroy_all
    cart_items = CartItem.all
    cart_items.destroy_all
    　render 'cart'
  end

  

private
 
  def cart_item_params
    params.require(:cart_item).permit(:amount, :item_id)
  end
end
