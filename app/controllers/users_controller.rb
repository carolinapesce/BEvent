class UsersController < ApplicationController
  before_action :authenticate_user!

  def profile
    @user = current_user
    @upcoming_events = @user.events.where(status: 'upcoming').order(:start_datetime)
    @terminated_events = @user.events.where(status: 'terminated').order(:start_datetime)
  end
  
  def show
    @user = User.find(params[:id])
    @upcoming_events = @user.events.where(status: 'upcoming').order(:start_datetime)
    @terminated_events = @user.events.where(status: 'terminated').order(:start_datetime)
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
    @user = current_user
    @favourites = @user.favourite_events
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :role)
  end

end
