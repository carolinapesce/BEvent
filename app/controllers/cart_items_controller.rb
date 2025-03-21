class CartItemsController < ApplicationController

  def current_cart
    @current_cart
  end

  # se l'evento è già presente nel carrello, aumenta il numero, altrimenti lo inserisce 
  def create
    
    event_id = params[:event_id]
    event = event.find(event_id)

    if (@cart_item = @current_cart.cart_items.find_by(:event_id => event_id))
      increment_number
    else
      @cart_item = CartItem.create(cart_id: @current_cart.id, event_id: event_id, quantity: 1)
    end
  
    if @cart_item.save
      redirect_to cart_path(@current_cart)
    else
      redirect_to events_path, alert: @cart_item.errors.full_messages.join(", ")
    end
  end
  
  # se è possibile comprare più biglietti, aumenta la quantità, altrimenti da un errore
  def increment_number
    @cart_item = CartItem.find(params[:cart_item_id])
    if (@cart_item.quantity + 1) > (@cart_item.event.max_participants - @cart_item.event.current_participants)
      flash[:notice] = "It's not possible to add additional ticket of #{@cart_item.event.title}."
      redirect_to cart_path(@current_cart)
      return
    end
    @cart_item.quantity += 1
    @cart_item.save
    redirect_to cart_path(@current_cart)
  end
    
  def decrease_number
    @cart_item = CartItem.find(params[:cart_item_id])
    @cart_item.quantity -= 1
    if @cart_item.quantity == 0
      @cart_item.destroy
    end
    @cart_item.save
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
