class SupportsController < ApplicationController
  before_action :authenticate_user!

  def new
    @support = Support.new
  end

  def create
    @support = current_user.supports.build(support_params)
  
    if @support.save
      SupportMailer.support_email(@support).deliver_now!
      redirect_to root_path, notice: "Email inviata con successo!"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  private

  def support_params
    params.require(:support).permit(:subject, :message)
  end
end
