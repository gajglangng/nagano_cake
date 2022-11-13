class Admin::OrderDetailsController < ApplicationController
  layout 'admin'
  
    def update
        # 制作ステータス
        @order_detail = OrderDetail.find(params[:id])
        @order_detail.making_status = params[:order_detail][:making_status]
        @order_detail.save
        @order_details = OrderDetail.where(order_id: @order_detail.order_id)
        if @order_detail.making_status == "製作中"
            @order_detail.order.update(status: "製作中")
        elsif @order_detail.making_status == "製作完了"
            complete_status = @order_detail.pluck(:making_status).grep("製作完了")
            if complete_status.size == @order_detail.count
                @order_detail.order.update(status: "発送準備中")
            end
        end
        redirect_to admin_order_path(@order_detail.order)
    end

    private
    def order_detail_params
        params.require(:order_detail).permit(:making_status)
    end
end
