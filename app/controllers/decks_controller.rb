class DecksController < ApplicationController
  def index
    @decks = Deck.all.order(id: :desc)
  end

  # /decks/search?term=
  def search
    decks = if params[:term].present?
              Deck.where('name LIKE ?', "#{params[:term]}%").pluck(:name)
            else
              Deck.pluck(:name)
            end

    render json: decks
  end
end
