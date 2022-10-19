class Public::OrdersController < ApplicationController
    
  before_action :authenticate_customer!

    def new #注文情報入力画面
        @customer = current_customer
        @orders = current_customer.orders.new
    end

    def confirm
        @order = Order.new(order_params)
        binding.pry #追記する
        @address = Address.find(params[:order][:address_id])
        @order.postal_code = @address.postal_code
        @order.address = @address.address
    @order.name = @address.name
    end

    def create #注文情報登録
        @order = Order.new(order_params)
        @order.customer_id = current_customer.id
        @order.name = params[:order][:name]
        @order.postal_code = params[:order][:postal_code]
        @order.address = params[:order][:address]
        @order.payment_method = params[:order][:payment_method]
        @order.total_payment = params[:order][:billing_amount]
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
        @customer = current_customer
        @order = Order.find(params[:id])
        @order_items = OrderDetail.where(order_id: params[:id])
    end


    private
    def order_params
        params.require(:order).permit(:payment_method, :postal_code, :address, :name)
    end
end
