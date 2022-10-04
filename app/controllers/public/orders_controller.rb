class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!

    def new #注文情報入力画面
        @customer = current_customer
        @orders = current_customer.orders.new
    end

    def confirm #注文情報確認
        @customer = current_customer
        @cart_items = CartItem.where(customer_id: current_customer.id)
        @shipping_fee = 800
        @total_price = 0
        @cart_items.each do |cart_item|
          @total_price += cart_item.subtotal
        end
        
        @billing_amount = @shipping_fee + @total_price
        @order = current_customer.orders.new(order_params)
        case params[:delivery_address_type]
        when "ご自身の住所"
             
        when "登録済住所から選択"
             
        when "新しいお届け先"
            
        end
    end

    def create #注文情報登録
        @order = Order.new(order_params)
        @order.customer_id = current_customer.id
        @order.name = params[:order][:name]
        @order.postcode = params[:order][:postcode]
        @order.address = params[:order][:address]
        @order.payment_method = params[:order][:payment_method]
        @order.billing_amount = params[:order][:billing_amount]
        @order.shipping_fee = 800
        @order.save
          current_customer.cart_items.each do |cart_item|
            @order_item = @order.order_items.new
            @order_item.order_id = @order.id
            @order_item.item_id = cart_item.item_id
            @order_item.item_count = cart_item.item_count
            @order_item.price_including_tax = (cart_item.item.price * 1.1).round(2).ceil
            @order_item.save
          end
        current_customer.cart_items.destroy_all
        redirect_to orders_complete_path
    end

    def order_complete #注文完了
        @customer = current_customer
    end

    def index #注文履歴一覧
        @customer = current_customer
        @orders = current_customer.orders.all
    end

    def show #注文履歴詳細
        @customer = current_customer
        @order = Order.find(params[:id])
        @order_items = OrderItem.where(order_id: params[:id])
    end


    private

    def order_params
        params.permit(:payment_method, :address, :postcode, :name, :billing_amount)
    end
end
