class EventsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_event, only: [:show]

  def index
    @user = current_user
    @events = Event.all
  end

  def search
    @user = current_user
    @events = Event.all
  end

  def show
    @user = current_user
    # @event = Event.find(params[:id])
  end

  def new
    #@user = current_user
    authorize! :create, Event
    @event = Event.new
  end

  def create
    puts ">>> Entrato nel metodo CREATE"
    puts ">>> Ruolo utente: #{current_user.role}"
    unless current_user.event_planner?
      redirect_to root_path, alert: "Solo i planner possono creare eventi." and return
    end
    puts ">>> SONO QUI"

    if params[:event][:charity_event] == true
      @event = CharityEvent.new(event_params)
    else
      @event = Event.new(event_params)
    end
    
    @event.user = current_user

    if @event.save
      redirect_to events_path, notice: "Evento creato con successo!"
    else
      flash[:alert] = "Errore nella creazione dell'evento: #{@event.errors.full_messages.to_sentence}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title,:description,:address,:start_datetime,:end_datetime,:category,:event_type,:max_participants,:charity_event,
                                  :beneficiary,:fundraiser_goal,:city,:country,:poster_pic)
  end

end
