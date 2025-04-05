class UsersController < ApplicationController
  before_action :authenticate_user!

  def my_events
    @events = Event.where(user_id: current_user.id)
    @query = params[:query]
    @city = params[:city]
    @category = params[:category]
    if @query.present?
      @events = @events.where("title LIKE ? OR description LIKE ?", "%#{@query}%", "%#{@query}%")
    end

    if @city.present?
      @events = @events.where("city LIKE ?", "%#{@city}%")
    end

    if @category.present?
      @events = @events.where("category LIKE ?", "%#{@category}%")
    end
    render 'users/my_events'
  end

  def show
    @user = User.find(params[:id])
    @tickets = @user.tickets.includes(:event)
    
    if @user.role == 0
      @upcoming_events = @tickets
        .map(&:event)
        .compact
        .select { |event| event.status == 'upcoming' }
        .sort_by(&:start_datetime)
    
      @terminated_events = @tickets
        .map(&:event)
        .compact
        .select { |event| event.status == 'terminated' }
        .sort_by(&:start_datetime)
    else
      @upcoming_events = @user.events.where(status: 'upcoming')
      @terminated_events = @user.events.where(status:'terminated')
    end
      
    render 'users/show'
  end  

  def edit
    @user = User.find(params[:id])
    # render 'users/edit'
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to @user, notice: "Profilo aggiornato con successo"
    else
      render :edit
    end
  end

  def destroy

  end

  def favourite
    authorize! :read, Favourite
    @user = current_user
    @favourites = @user.favourite_events
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :role, :city, :phone_number, :profile_pic, :bio)
  end

end
