class Public::CartItemsController < ApplicationController
  
  before_action :authenticate_customer!

  def cart
    #@customer = current_customer
    #@cart_items = CartItem.new(params[:id])
    #@cart_items = current_customer.cart_items.all
    #@price = 0   
    @cart_items = current_customer.cart_items.all
    #@item = cart.items   
    
  end

  def create
    #@amount = params[:amount] ? params[:amount] : params[:cart_item][:amount]
    @cart_item = current_customer.cart_items.new(cart_item_params)
    # もし元々カート内に「同じ商品」がある場合、「数量を追加」更新・保存する
        #ex.バナナ２個、バナナ２個ではなく　バナナ「4個」にしたい
        if current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id]).present?
                          #元々カート内にあるもの「item_id」　
                          #今追加した　　　　　　　params[:cart_item][:item_id])
            cart_item = current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])
            cart_item.amount += params[:cart_item][:amount].to_i
           #cart_item.quantityに今追加したparams[:cart_item][:quantity]を加える
                                                              #.to_iとして数字として扱う
    #@cart_item = CartItem.new({customer_id:params[:customer_id], item_id:params[:item_id], amount:@amount})
    #@item = Item.find(cart_item_params)
            redirect_to cart_items_path
            # もしカート内に「同じ」商品がない場合は通常の保存処理 
        elsif @cart_item.save
              @cart_items = current_customer.cart_items.all
              redirect_to cart_items_path
        else　# 保存できなかった場合
            render "public/items/show"
        end

    #@item = Item.find(params[:item_id])
      #@genres = Genre.where(is_valid: true)
     #render "public/items/show"
    #end
    
    
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
    #@cart_items = CartItem.all
     redirect_to cart_items_path
  end


  def destroy_all
    #CartItem.where(customer_id: current_customer.id).destroy_all
   current_customer.cart_items.destroy_all
     redirect_to cart_items_path
  end

  

private
 
  def cart_item_params
    params.require(:cart_item).permit(:item_id, :price, :amount)
  end
end
