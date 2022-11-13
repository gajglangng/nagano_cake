# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  #before_action :customer_state, only: [:create]
  
  protected
  
  def customer_state
    @customer = Customer.find_by(email: sign_in_params[:email])
      if @customer.is_deleted == false
        redirect_to new_customer_session_path, danger: "退会済みのユーザーです。"
      end

  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  
  
end
