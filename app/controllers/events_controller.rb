class EventsController < ApplicationController

  before_action :authenticate_user!

  def index
    @events = Event.all
  end

  def show
    # @user = current_user
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
    params.require(:event).permit(:title,:description,:address,:start_datetime,:end_datetime,:category,:type,:max_participants,
                                  :beneficiary,:fundraiser_goal,:city,:country)
  end

end
