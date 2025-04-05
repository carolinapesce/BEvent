class Admin::Events::ReviewsController < ApplicationController

    before_action :authenticate_user!
    before_action :authorize_admin!
    before_action :set_event, only: [:index, :edit, :update, :destroy]
    before_action :set_review, only: [:edit, :edit, :update, :destroy]

    # Mostra tutte le recensioni
    def index
      @reviews = @event.reviews if @event.reviews.present?
    end

    # Modifica la recensione
    def edit
      @review = Review.find(params[:id])
      @event = @review.event
    end

    # Aggiorna la recensione
    def update
      @review = Review.find(params[:id]) 
      @event = @review.event   
      if @review.update(review_params)
        @review.event.update_average_rating
        redirect_to admin_event_reviews_path(@event.id), notice: 'Recensione aggiornata con successo.'
      else
        render :edit
      end
    end

    # Elimina la recensione
    def destroy
      @review = Review.find(params[:id])
      @event = @review.event
      @review.destroy
      @review.event.update_average_rating
      redirect_to admin_event_reviews_path(@event.id), notice: 'Recensione eliminata con successo.'
    end

    private

    # Trova la recensione per ID
    def set_review
      @review = Review.find(params[:id])
    end

    def set_event
      @event = Event.find(params[:event_id]) # Assicurati di avere params[:event_id] per ottenere l'evento
    end

    # Definisci i parametri permessi per la recensione
    def review_params
      params.require(:review).permit(:content, :rating, :event_id, :user_id)
    end

    # Autorizza solo gli admin
    def authorize_admin!
      redirect_to root_path, alert: "Accesso negato" unless current_user.admin?
    end
  
end