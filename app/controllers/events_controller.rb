class EventsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :set_event, only: [:show]

  load_and_authorize_resource @event

  def index
    check_if_blocked
    @user = current_user
    @events = Event.all
    @load_maps = !request.fullpath.include?('maps')
    @events = Event.where(status: "upcoming").or(Event.where(status: "ongoing")).order(:start_datetime)
  end

  def search
    @user = current_user
    @events = Event.all
    @google_maps_api_key = ENV['GOOGLE_MAPS_API_KEY']
    Rails.logger.debug("Google Maps API Key: #{@google_maps_api_key}")

    #@pagy, @events = pagy(Event.where(status: "upcoming").or(Event.where(status: "ongoing")).order(:start_datetime), limit: 5)

    @query = params[:query]
    @city = params[:city]
    if @query.present?
      @events = @events.where("title LIKE ? OR description LIKE ?", "%#{@query}%", "%#{@query}%")
    end

    if @city.present?
      @events = @events.where("city LIKE ?", "%#{@city}%")
    end

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
      time_filters = []
      time_filters << "(CAST(strftime('%H', start_datetime) AS INTEGER) BETWEEN 6 AND 11)" if params[:time][:morning].present?
      time_filters << "(CAST(strftime('%H', start_datetime) AS INTEGER) BETWEEN 12 AND 18)" if params[:time][:afternoon].present?
      time_filters << "(CAST(strftime('%H', start_datetime) AS INTEGER) BETWEEN 19 AND 23)" if params[:time][:evening].present?
      @events = @events.where(time_filters.join(" OR ")) if time_filters.any?
    end
    # Filtro Evento di Beneficenza
    if params[:charity_only] == "true"
      @events = @events.where(charity_event: true)
    end
    # Filtro categoria
    if params[:category].present?
      @events = @events.where(category: params[:category])
    end

    @pagy, @events = pagy(@events.where(status: "upcoming").or(Event.where(status: "ongoing")).order(:start_datetime), limit: 5)

  end

  def show
    @user = current_user
    @events = Event.all
    @organizer = @event.user
    @event = Event.find(params[:id])
  end

  def new
    #@user = current_user
    unless current_user.event_planner? || current_user.admin?
      redirect_to root_path, alert: "Solo i planner possono creare eventi." and return
    end
    @event = Event.new
  end

  def create
    puts ">>> Entrato nel metodo CREATE"
    puts ">>> Ruolo utente: #{current_user.role}"
    unless current_user.event_planner? || current_user.admin?
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
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      users = @event.users_who_bought
      users.each do |user|
        EventMailer.event_user_updated(@event, user).deliver_now!
      end
      redirect_to user_my_events_path(current_user), notice: 'Evento aggiornato con successo.'
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to user_my_events_path(current_user), notice: 'Evento eliminato con successo.'
  end

  def check_if_blocked
    if current_user.blocked?
      sign_out current_user
      redirect_to root_path
    end
  end  

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title,:description,:address,:start_datetime,:end_datetime,:category,:event_type,:max_participants,:event_price,
                                  :charity_event, :beneficiary,:fundraiser_goal,:city,:country,:poster_pic)
  end

end
