class EventsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :set_event, only: [:show]

  def index
    @user = current_user
    @events = Event.all
  end

  def search
    @user = current_user

    @pagy, @events = pagy(Event.all, limit: 5)

    # Filtro data
    if params[:start_datetime].present?
      @events = @events.where("start_datetime >= ?", params[:start_datetime])
    end
    if params[:end_datetime].present?
      @events = @events.where("end_datetime <= ?", params[:end_datetime])
    end
    # Filtro prezzo
    if params[:min_price].present?
      @events = @events.where("event_price >= ?", params[:min_price])
    end
    if params[:max_price].present?
      @events = @events.where("event_price <= ?", params[:max_price])
    end
    # Filtro orario
    if params[:time].present?
      if params[:time][:morning] == true
        @events = @events.where("start_datetime BETWEEN ? and ?", DateTime.parse("2025-03-22 06:00"), Time.parse("2025-03-22 12:00"))
      end
      if params[:time][:afternoon] == true
        @events = @events.where("start_datetime BETWEEN ? and ?", DateTime.parse("2025-03-22 12:01"), Time.parse("2025-03-22 18:00"))
      end
      if params[:time][:evening] == true
        @events = @events.where("start_datetime BETWEEN ? and ?", DateTime.parse("2025-03-22 18:01"), Time.parse("2025-03-22 23:59"))
      end
    end
    # Filtro Evento di Beneficenza
    if params[:charity_only] == "true"
      @events = @events.where(charity_event: true)
    end
    # Filtro categoria
    if params[:category].present?
      @events = @events.where(category: params[:category])
    end

    

  end

  def show
    @user = current_user
    @events = Event.all
    # @event = Event.find(params[:id])
  end

  def new
    #@user = current_user
    unless current_user.event_planner?
      redirect_to root_path, alert: "Solo i planner possono creare eventi." and return
    end
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
