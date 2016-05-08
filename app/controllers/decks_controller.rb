class DecksController < ApplicationController
  def index
    @decks = Deck.all.order(id: :desc)
  end
end
