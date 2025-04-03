class Admin::SupportsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def index
    @supports = Support.where(response: nil)
  end

  def show
    @support = Support.find(params[:id])
  end

  def update
    @support = Support.find(params[:id])
    if @support.update(response_params)
      SupportMailer.response_email(@support).deliver_now!
      redirect_to admin_supports_path, notice: "Risposta inviata con successo."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def response_params
    params.require(:support).permit(:response)
  end

  def authorize_admin!
    redirect_to root_path, alert: "Non autorizzato" unless current_user.admin?
  end
end
