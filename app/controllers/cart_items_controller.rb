class CartItemsController < ApplicationController

  def current_cart
    @current_cart
  end

  # se l'evento è già presente nel carrello, aumenta il numero, altrimenti lo inserisce 
  def create
    event_id = params[:event_id]
    event = Event.find(event_id)
    donation_amount = params[:donation_amount].to_f if event.charity_event?
    user_id = params[:user_id]
    message = params[:message] if event.charity_event?
    anonymous = params[:anonymous] == "1"
    @cart_item = @current_cart.cart_items.find_or_initialize_by(event_id: event_id, donation_amount: donation_amount, message: message, anonymous: anonymous)
    
    if @cart_item.new_record?
      @cart_item.quantity = 1
      @cart_item.donation_amount = donation_amount if @cart_item.donation_amount.present?
    else
      @cart_item.increment!(:quantity)
    end
  
    if @cart_item.save
      #@donation = Donation.create!(
      #      event_id: event.id,
      #      user_id: user_id,
      #      amount: donation_amount, 
      #      message: message, 
      #      anonymous: anonymous
      #    )
      flash[:success] = "Evento aggiunto al carrello !"
      redirect_to cart_path(@current_cart)
    else
      flash[:alert] = @cart_item.errors.full_messages.to_sentence
      redirect_to events_path
    end
  end  
  
  # se è possibile comprare più biglietti, aumenta la quantità, altrimenti da un errore
  def increment_number
    @cart_item = CartItem.find(params[:cart_item_id])
    availability = @cart_item.event.max_participants - @cart_item.event.current_participants
  
    if @cart_item.quantity < availability
      @cart_item.increment!(:quantity)
      flash[:success] = "Biglietto aggiunto !"
    else
      flash[:alert] = "Non è possibile aggiungere un altro biglietto per #{@cart_item.event.title}."
    end
  
    redirect_to cart_path(@current_cart)
  end
    
  def decrease_number
    @cart_item = CartItem.find(params[:cart_item_id])
    @cart_item.decrement!(:quantity)
    @cart_item.destroy if @cart_item.quantity.zero?
    redirect_to cart_path(@current_cart)
  end

  def destroy
    @cart_item = CartItem.find(params[:cart_item_id])
    if @cart_item.destroy
      redirect_to cart_path(@current_cart)
    else 
      redirect_to root_path, alert: @cart_item.errors.full_messages.join(", ")
    end
  end  
    
  private

  def cart_item_params
    params.require(:cart_item).permit(:quantity, :event_id, :cart_id)
  end
end
