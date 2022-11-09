class Public::OrdersController < ApplicationController

  before_action :authenticate_customer!

    def new #注文情報入力画面
        @customer = current_customer
        @order = Order.new
        @addresses = current_customer.addresses.all
    end

    def confirm
         @order = Order.new(order_params)
         @cart_items = CartItem.where(customer_id: current_customer.id)
         @order_postage = 800
         @total_price = 0
         @cart_items.each do |cart_item|
          tax_price = ((cart_item.item.price * 1.1).round(2)).ceil * (cart_item.amount)
          @total_price += tax_price
        end
         
         @total_payment = @order_postage + @total_price
      
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
        
    end

    def create #注文情報登録
        @order = Order.new(order_params)
        @order.customer_id = current_customer.id
        @order.name = params[:order][:name]
        @order.postal_code = params[:order][:postal_code]
        @order.address = params[:order][:address]
        @order.payment_method = params[:order][:payment_method]
        @order.total_payment = params[:order][:total_payment]
        @order.postage = 800
        @order.save
        
          current_customer.cart_items.each do |cart_item|
            @order_detail = OrderDetail.new 
            @order_detail.order_id = @order.id
            @order_detail.item_id = cart_item.item_id
            @order_detail.amount = cart_item.amount
            @order_detaile.price = (cart_item.item.price * 1.1).round(2).ceil
            @order_detail.save
          end
             redirect_to orders_complete_path
             cart_items.destroy_all
    end

    def show #注文履歴詳細
        #@customer = current_customer
        #@order = Order.find(params[:id])
        @order_items = OrderDetail.where(order_id: params[:id])
    end

    # 注文履歴
    def index
        @orders = current_member.orders
    end

    private
     def order_params
        params.require(:order).permit(:payment_method, :postage, :postal_code, :address, :name, :customer_id, :total_payment, :order_status)
     end
     
     def delivery_address_type_params
        params.permit(:delivery_address_type)
     end
     
     
end
