class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_role

  def show
  end

  private 

  def check_admin_role
    redirect_to root_path, alert: "Accesso non autorizzato" unless current_user.role == 2
  end

end
