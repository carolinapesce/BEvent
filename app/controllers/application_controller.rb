class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_user, :set_current_cart
  #helper_method :current_cart

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  #def current_cart
  #  @current_cart ||= set_current_cart
  #end

  private

  def set_current_user
    @current_user = current_user
  end

  # se il carrello è nil, viene creato
  def set_current_cart
    if session[:cart_id].nil?
      @current_cart = Cart.create
      session[:cart_id] = @current_cart.id
    else
      @current_cart = Cart.find_by(id: session[:cart_id]) || Cart.create
      session[:cart_id] = @current_cart.id
    end
  end 

  include Pagy::Backend
  
end
