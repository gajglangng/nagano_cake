class Public::AddressesController < ApplicationController
  before_action :authenticate_customer!

  def index
    @address = Address.new
    @customer = Customer.find(current_customer.id)
    @addresses = @customer.address
  end

  def create
    @address = Address.new(address_params)
    @address.customer_id = current_customer.id
    if @address.save
      redirect_to addresses_path
    else
      @customer = Customer.find(current_customer.id)
      @addresses = @customer.address
      @addresses = Address.all
      render 'index'
    end
  end

  def edit
    @customer = current_customer
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      redirect_to addresses_path
    else
      render 'edit'
    end
  end


  def destroy
    @address = Address.find(params[:id])
    @address.destroy
    redirect_to addresses_path
  end


private

def address_params
  params.require(:address).permit(:name, :address, :postal_code)
end

end