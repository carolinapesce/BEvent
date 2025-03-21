class EventsController < ApplicationController

  before_action :authenticate_user!

  def index
    @user = current_user
    @events = Event.all
    @load_maps = !request.fullpath.include?('maps')
  end

  def search
    @user = current_user
    @events = Event.all
    @google_maps_api_key = ENV['GOOGLE_MAPS_API_KEY']
    Rails.logger.debug("Google Maps API Key: #{@google_maps_api_key}")
  end

  def show
    @user = current_user
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save # if saved successfully
      redirect_to :action => 'index', notice: "Evento creato con successo!" #  redirect to books list
    
    else
      flash[:alert] = "Errore nella creazione dell'evento."
      render :action => 'new', status: :unprocessable_entity # if unsuccessful, refresh new page
    end
  end

  def edit
  end

  def event_params
    params.require(:event).permit(:title,:description,:address,:start_datetime,:end_datetime,:category,:event_type,:max_participants,
                                  :beneficiary,:fundraiser_goal,:city,:country)
  end

end
