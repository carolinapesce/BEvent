class ReviewsController < ApplicationController

  def index
    @reviews = Review.all
  end 

  def new
    Review.new
  end 

  def create
    @review = Review.new(review_params)
    if @user.save
      redirect_to checkouts_index_path(current_user), notice: 'Recensione creata con successo.'
    else
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
    redirect_to checkouts_index_path(current_user), notice: 'Recensione eliminata con successo.'
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating, :user_id, :event_id)
  end

end
