class CheckoutsController < ApplicationController

  def index
    @user_checkouts = @current_user
  end

  def show
  end

  def success
    session = Stripe::Checkout::Session.retrieve(id: params[:session_id])
    if !session.nil?
      @current_cart.decrease_availability
      checkout = Checkout.create(user: @current_user, cart: @current_cart)
      checkout.save
      @success_session = Stripe::Checkout::Session.retrieve(id: params[:session_id], expand: ['line_items'])
      @current_cart.destroy
    else
      redirect_to cancel_url(session: session)
    end
  end

  def cancel
    @cancel_session = Stripe::Checkout::Session.retrieve(id: params[:session_id], expand: ['line_items'])
  end

  def create
    line_items_json = @current_cart.cart_items.map do |item|
      { price: item.event.stripe_price_id, quantity: item.quantity}
    end

    @session = Stripe::Checkout::Session.create({
        customer: @current_user.stripe_customer_id,
        payment_method_types: ['card'],
        line_items: line_items_json,
        mode: 'payment',
        success_url: checkouts_success_url + "?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: checkouts_cancel_url + "?session_id={CHECKOUT_SESSION_ID}"
    })
    redirect_to @session.url, allow_other_host: true
  end

end