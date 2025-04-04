class Admin::EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_role

  def index
    @events = Event.all
    @query = params[:query]
    @city = params[:city]
    @category = params[:category]
    if @query.present?
      @events = @events.where("title LIKE ? OR description LIKE ? OR user.email LIKE ?", "%#{@query}%", "%#{@query}%", "%#{@query}%")
    end

    if @city.present?
      @events = @events.where("city LIKE ?", "%#{@city}%")
    end

    if @category.present?
      @events = @events.where("category LIKE ?", "%#{@category}%")
    end
  end

  def new
    @event = Event.new
    @event_planners = User.where(role: 1).order(:first_name) # 1 = Event Planner
  end

  def create
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
      EventMailer.event_planner_updated(@event, @event.user).deliver_now!
      redirect_to admin_events_path, notice: 'Evento aggiornato con successo.'
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to admin_events_path, notice: 'Evento eliminato con successo.'
  end

  private

  def check_admin_role
    redirect_to root_path, alert: "Accesso non autorizzato" unless current_user.role == 2
  end

  def event_params
    params.require(:event).permit(:title,:description,:address,:start_datetime,:end_datetime,:category,:event_type,:max_participants,:event_price,
                                  :charity_event, :beneficiary,:fundraiser_goal,:city,:country,:poster_pic)
  end
end
