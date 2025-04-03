class ReviewsController < ApplicationController


  before_action :authenticate_user!
 
  def index
    @reviews = Review.all
  end 

  def new
    @event = Event.find(params[:event_id])
    @review = Review.new
  end 

  def create
    @review = current_user.reviews.new(review_params)
    
    if @review.save
      redirect_to checkouts_index_path(current_user), notice: 'Recensione inviata con successo!'
    else
      @event = @review.event
      render :new
    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    if @review.update(review_params)
      redirect_to checkouts_index_path(current_user), notice: 'Recensione aggiornata con successo.'
    else
      render :edit
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to tickets_path(current_user), notice: 'Recensione eliminata con successo.'
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating, :user_id, :event_id)
  end

end
