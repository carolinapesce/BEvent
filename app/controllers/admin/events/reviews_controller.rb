class Admin::Events::ReviewsController < ApplicationController

    before_action :authenticate_user!
    before_action :authorize_admin!
    before_action :set_review, only: [:edit, :update, :destroy]

    # Mostra tutte le recensioni
    def index
      @reviews = Review.all
      
    end

    # Modifica la recensione
    def edit
    end

    # Aggiorna la recensione
    def update
        @event = Review.event
      if @review.update(review_params)
        redirect_to admin_event_reviews_path(@event.id), notice: 'Recensione aggiornata con successo.'
      else
        render :edit
      end
    end

    # Elimina la recensione
    def destroy
        @event = Review.find(params[:event_id])
      @review.destroy
      redirect_to admin_event_reviews_path(@event.id), notice: 'Recensione eliminata con successo.'
    end

    private

    # Trova la recensione per ID
    def set_review
      @review = Review.find(params[:id])
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