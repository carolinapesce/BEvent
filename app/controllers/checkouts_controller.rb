class CheckoutsController < ApplicationController

  def index
    @user_checkouts = Checkout.where(user_id: @current_user.id).includes(cart: { cart_items: :event }).order(completed_at: :desc)
    puts @user_checkouts
  end

  def show
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(id: params[:session_id], expand: ['line_items'])
    if @session.nil?
      redirect_to cancel_url(session: @session)
    else
      @checkout = Checkout.create(user_id: @current_user.id, 
                                  cart_id: @current_cart.id,
                                  stripe_session_id: @session.id,
                                  total_amount: @session.amount_total,
                                  completed_at: Time.now)
      @checkout.save

      @current_cart.cart_items.each do |cart_item|
        @ticket = Ticket.create(user_id: @current_user.id,
                      event_id: cart_item.event_id,
                      price: cart_item.event.event_price,
                      booked_datetime: cart_item.event.start_datetime,
                      quantity: cart_item.quantity)
      end
      @ticket.save

      @current_cart.cart_items.each do |cart_item|
        if cart_item.event.charity_event? 
          Donation.create!(
            user_id: @current_user.id,
            event_id: cart_item.event_id,
            amount: cart_item.donation_amount,
            anonymous: cart_item.anonymous,  
            message: cart_item.message       
          )
          cart_item.event.current_funds += cart_item.donation_amount
        end
      end

      @current_cart.decrease_availability
      @current_cart.cart_items.each do |cart_item|
        @current_cart.update(cart_item_id: cart_item.id) # Salva l'id del cart_item nel carrello
      end

      @success_session = @session
      @line_items = @session.line_items.data
      
      @new_cart = Cart.create(cart_item_id: nil)
      session[:cart_id] = @new_cart.id

      TicketMailer.confirmation(@checkout).deliver_now!
    end
  end

  def cancel
    @cancel_session = Stripe::Checkout::Session.retrieve(id: params[:session_id], expand: ['line_items'])
  end

  def create
    line_items_json = @current_cart.cart_items.map do |item|
      if item.event.charity_event? && item.donation_amount.present?
        price = Stripe::Price.create({
          unit_amount: (item.donation_amount * 100).to_i,
          currency: 'eur',
          product_data: { name: "Donazione per #{item.event.title}" }
        })
        { price: price.id, quantity: 1 }
      else
        { price: item.event.stripe_price_id, quantity: item.quantity }
      end
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