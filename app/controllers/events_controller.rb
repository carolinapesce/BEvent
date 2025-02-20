class EventsController < ApplicationController

  before_action :authenticate_user!

  def index
    @events = Event.all
  end

  def show
    @user = current_user
    @event = Event.find(params[:id])
  end

  def new
    @user = current_user
    @product = @user.products.build
  end

  def edit
  end

  

end
