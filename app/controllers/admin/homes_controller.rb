class Admin::HomesController < ApplicationController
 before_action :authenticate_admin!

 def top
  case params[:order_sort]
  when "0"
   @orders = Order.where(created_at: Date.today.in_time_zone.all_day).page(params[:page]).per(10)
  when "1"
   @customer = Customer.find(params[:customer_id])
   @orders = @customer.orders.page(params[:page]).per(10)
  else
   @orders = Order.all.page(params[:page]).per(10)
  end
 end



 
end
