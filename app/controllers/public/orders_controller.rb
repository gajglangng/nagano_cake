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
        
        # ordered_itmemの保存
        current_customer.cart_items.each do |cart_item| #カートの商品を1つずつ取り出しループ
          @order_detail = OrderDetail.new #初期化宣言
          @order_detail.item_id = cart_item.item_id #商品idを注文商品idに代入
          @order_detail.amount = cart_item.amount #商品の個数を注文商品の個数に代入
          @order_detail.price = (cart_item.item.price*1.1).floor #消費税込みに計算して代入
          @order_detail.order_id =  @order.id #注文商品に注文idを紐付け
          @order_detail.save #注文商品を保存
        end #ループ終わり
            
            current_customer.cart_items.destroy_all
            redirect_to orders_complete_path
    end

    def show #注文履歴詳細
        @item = Item.find(params[:item_id])
        @order = @item.order.new
    end

    # 注文履歴
    def index
        @orders = current_customer.orders.all
    end

    private
     def order_params
        params.require(:order).permit(:payment_method, :postage, :postal_code, :address, :name, :customer_id, :total_payment, :order_status, :item_id)
     end
     
     def delivery_address_type_params
        params.permit(:delivery_address_type)
     end
     
     
end
