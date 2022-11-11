class Public::CartItemsController < ApplicationController
  
  before_action :authenticate_customer!

  def cart
    @customer = current_customer
    @cart_items = CartItem.where(customer_id: current_customer.id)
    #@cart_item = CartItem.all
  end

  def create
    @cart_item_check = CartItem.find_by(customer_id: current_customer.id, item_id: params[:cart_item][:item_id])
    if @cart_item_check
      @cart_item_check.amount += params[:cart_item][:amount].to_i
      @cart_item_check.save
      flash[:success] = "カートに存在済のアイテムです"
      redirect_to cart_items_path
    else
      @cart_item = CartItem.new(cart_item_params)
      @cart_item.customer_id = current_customer.id
      if @cart_item.save
        flash[:success] = "カートに追加しました"
        redirect_to cart_items_path
      else
        flash[:danger] = "予期せぬエラーが発生しました"
        redirect_back(fallback_location: root_path)
      end
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(cart_item_params)
    redirect_to cart_items_path
  end

  def destroy_all
    current_customer.cart_items.destroy_all
    redirect_to cart_items_path, notice: 'カートが空になりました。' 
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to cart_items_path
  end

  

private
 
  def cart_item_params
    params.require(:cart_item).permit(:item_id, :amount, :customer_id)
  end
end