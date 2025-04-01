class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_role

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: 'Utente creato con successo.'
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'Utente aggiornato con successo.'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: 'Utente eliminato con successo.'
  end

  private

  def check_admin_role
    redirect_to root_path, alert: "Accesso non autorizzato" unless current_user.role == 2
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role)
  end
end
