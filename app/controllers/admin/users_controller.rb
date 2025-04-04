class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_role

  def index
    @users = User.all
    @query = params[:query]
    @role = params[:role]
    if @query.present?
      @users = @users.where("first_name LIKE ? OR last_name LIKE ? OR email LIKE ?", "%#{@query}%", "%#{@query}%", "%#{@query}%")
    end
    if @role.present?
      role_mapping = {
        "User" => 0,
        "Event Planner" => 1,
        "Admin" => 2
      }
      role_value = role_mapping[@role]
      @users = @users.where(role: role_value) if role_value.present?
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.confirmed_at = Time.now
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
      UserMailer.account_updated(user).deliver_now!
      redirect_to admin_users_path, notice: 'Utente aggiornato con successo.'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    UserMailer.account_destroyed(user).deliver_now!

    redirect_to admin_users_path, notice: 'Utente eliminato con successo.'
  end

  def block
    user = User.find(params[:id])
    user.update(blocked: true)

    UserMailer.account_blocked(user).deliver_now!

    redirect_to admin_users_path, notice: "L'utente #{user.email} è stato bloccato."
  end

  def unblock
    user = User.find(params[:id])
    user.update(blocked: false)
    redirect_to admin_users_path, notice: "L'utente #{user.email} è stato sbloccato."
  end

  private

  def check_admin_role
    redirect_to root_path, alert: "Accesso non autorizzato" unless current_user.role == 2
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role)
  end
end
