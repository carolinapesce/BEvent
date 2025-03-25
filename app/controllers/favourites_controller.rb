class FavouritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event

  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def create
    #event = Event.find(params[:event_id])
    #current_user.favourite_events.create(event: event) unless current_user.favorited?(event)
    #head :ok
    favourite = Favourite.create!(favourite_params)

    #respond_to do |format|
    #  format.turbo_stream do
    #    render turbo_stream: turbo_stream.replace("favorite-icon-#{favourite.event_id}", partial: "favorites/favorite_icon", locals: { event: favourite.event })
    #  end
    #  format.html { head :ok }
    #end

    render json: favourite, status: :created

  end

  def destroy
    favourite = Favourite.find(params[:id])
    favourite.destroy

    head :ok

  end

  private
  
  def favourite_params
    params.require(:favourite).permit(:user_id, :event_id, :favourite)
  end

  def set_event
    @event = Event.find(params[:event_id] || params[:id])
  end

end
