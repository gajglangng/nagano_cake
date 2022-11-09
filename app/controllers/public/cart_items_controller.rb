class Public::CartItemsController < ApplicationController
  
  before_action :authenticate_customer!

  def cart
    
    #@cart_item = CartItem.all
  end

  def create
    #@cart_item = current_customer.cart_items.new(cart_item_params)
    @cart_item = CartItem.new({customer_id:params[:customer_id], item_id:params[:item_id], amount:@amount})
     if current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id]).present?
                          #元々カート内にあるもの「item_id」　
                          #今追加した　　　　　　　params[:cart_item][:item_id])
            cart_item = current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])
            cart_item.amount += params[:cart_item][:amount].to_i
            cart_item.save
            redirect_to cart_items_path
            
     # もしカート内に「同じ」商品がない場合は通常の保存処理 
     elsif @cart_item.save
         　@cart_items = current_customer.cart_items.all
            render 'cart'
     else　# 保存できなかった場合
            render 'cart'
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
    params.require(:cart_item).permit(:item_id, :price, :amount)
  end
end
