class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  
  def show #注文履歴詳細
    @order = Order.find(params[:id])
    @order_items = OrderItem.where(order_id: params[:id])
    @total_fee = (@order.billing_amount - @order.shipping_fee).to_s(:delimited)
  end
   
  def order_params
    params.require(:order)
  end 
end
