class Public::CustomersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]

  def show
    @customer = Customer.find(params[:id])
  end

  def edit
    @customer = Customer.find(params[:id])
  end
  
  def unsubscribe
      @customer = current_customer
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(user_params)
      redirect_to customers_my_page_path
    else
      render 'edit'
    end
  end



  private
  def customer_params
     params.require(:customer).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :email, :postcode, :address, :phone_number)
  end

  
end
