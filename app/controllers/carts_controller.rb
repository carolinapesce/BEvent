class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :checks_oauth_params

  load_and_authorize_resource @current_cart

  def show
    @cart = @current_cart
  end

  def destroy
    session[:cart_id] = nil
    redirect_to root_path
  end

  private

  # controlla se i parametri dell'utente sono presenti (nome e cognome)
  def checks_oauth_params
    if @current_user.first_name.blank? || @current_user.last_name.blank?
      redirect_to edit_user_path(current_user)
      flash[:alert] = "Update your account with first name and last name."
    end
  end

end
