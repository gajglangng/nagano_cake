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
    @amount = params[:amount] ? params[:item_count] : params[:cart_item][:amount]
    @cart_item = CartItem.new({customer_id:params[:customer_id], item_id:params[:item_id], item_count:@amount})
    binding.pry
    if (CartItem.where(item_id: params[:item_id]).where(customer_id: current_customer.id).exists?) && (@amount.present?)
      @cart_item = CartItem.find_by(item_id: params[:item_id],customer_id: current_customer.id)
      @cart_item.item_count += @amount.to_i
      @cart_item.save
      redirect_to action: :cart
    elsif @cart_item.save
      redirect_to action: :cart
    else
      @item = Item.find(params[:item_id])
      @genres = Genre.where(is_valid: true)
      render "public/items/show"
    end
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
      params.require(:cart_item).permit(:item_id, :amount)
  end

  def cart_item_count_params
    params.require(:cart_item).permit(:customer_id, :item_id, :item_count)
  end
end
