class UsersController < ApplicationController
  before_action :authenticate_user!

  
  def show
    @user = current_user
    render 'users/show'
  end

  def edit
    @user = User.find(params[:id])
    # render 'users/edit'
  end

  def update
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
end
