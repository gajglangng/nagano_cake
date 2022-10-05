class Public::AddressesController < ApplicationController
  before_action :authenticate_customer!

  def index
    @address = Address.new
    @customer = Customer.find(current_customer.id)
    @addresses = @customer.shipping_addresses
  end

  


private

def address_params
  params.require(:address).permit(:name, :address, :postcode)
end

end
