class Public::OrdersController < ApplicationController
    
  before_action :authenticate_customer!

    def new #注文情報入力画面
        @customer = current_customer
        @orders = current_customer.orders.new
        #@order = Order.new
        #@addresses = current_customer.addresses.all
    end

    def confirm
        @order = Order.new(order_params)
        @customer = current_customer
        @cart_items = CartItem.where(customer_id: current_customer.id)
        
        
        case params[:delivery_address_type]
        when "ご自身の住所"
            @order.postal_code = current_customer.postal_code
            @order.address = current_customer.address
            @order.name = current_customer.last_name + current_customer.first_name 

        # collection.selectであれば
        when "登録済み住所から選択"
            ship = Address.find(params[:order][:member_id])
            @order.postal_code = ship.postal_code
            @order.address = ship.address
            @order.name = ship.name 

        # 新規住所入力であれば
        when "新しいお届け先"
            @order.post_code = params[:order][:postal_code]
            @order.address = params[:order][:address]
            @order.name = params[:order][:name]
        else
            render 'new'
        end
        
        @cart_items = current_customer.cart_items.all
        @order.customer_id = current_customer.id
            
    end

    def create #注文情報登録
        @order = Order.new(order_params)
        @order.customer_id = current_customer.id
        
        @order.save
        
          current_customer.cart_items.each do |cart_item|
            @order_item = @order.order_items.new
            @order_item.order_id = @order.id
            @order_item.item_id = cart_item.item_id
            @order_item.amount= cart_item.amount
            @order_item.price = (cart_item.item.price * 1.1).round(2).ceil
            @order_item.save
          end
        current_customer.cart_items.destroy_all
        redirect_to orders_complete_path
    end

    def complete #注文完了
        @customer = current_customer
    end

    def index #注文履歴一覧
        @customer = current_customer
        @orders = current_customer.orders.all
    end

    def show #注文履歴詳細
        #@customer = current_customer
        #@order = Order.find(params[:id])
        @order_items = OrderDetail.where(order_id: params[:id])
    end


    private
     def order_params
        params.permit(:payment_method, :postage, :postal_code, :address, :name, :customer_id, :total_payment, :order_status)
     end
end
