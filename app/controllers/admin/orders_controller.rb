class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'
  
  def index #注文履歴一覧
    @orders = Order.page(params[:page]).per(10)
    #@order_details = @order.order_details
  end

  
  def show #注文履歴詳細
    @order = Order.find(params[:id])
    @order_details = OrderDetail.where(order_id: params[:id])
    @order.postage = 800
    #@cart_items = CartItem.where(customer_id: current_customer.id)
    @total_price = 0
    @order_details.each do |order_detail|
      @total_price += order_detail.item.with_tax_price * order_detail.amount
    end
    @order.total_payment = @order.postage + @total_price
  end
   
  def update #注文ステータス
    @order = Order.find(params[:id])
    @order.update(order_params)
      if @order.status == "入金確認"
         @order.order_items.update(production_status: "製作待ち")
      end
      redirect_to admin_order_path(params[:id])
  end

  def new
    @order = Order.new
  end

   private

    def order_params
        params.require(:order).permit(:postage, :total_payment, :name, :payment_method, :address, :postal_code, :making_status, :order_status)
    end
end
