class DecksController < ApplicationController
  before_action :set_deck, only: [:update, :destroy]

  def index
    @decks = Deck.all.order(id: :desc)
  end

  def create
    @deck = Deck.new(deck_params)

    respond_to do |format|
      if @deck.save
        format.html { redirect(decks_path, 'Deck was successfully created') }
        format.json { render json: @deck }
      else
        format.html { render action: 'new' }
        format.json { render json: @deck.errors, status: 400 }
      end
    end
  end

  def update
    redirect_to root_path and return if @deck.nil?

    respond_to do |format|
      if @deck.update(deck_params)
        format.html { redirect(decks_path, 'Deck was successfully updated') }
        format.json { render json: @deck }
      else
        format.html { render :edit }
        format.json { render json: @deck.errors, status: 400 }
      end
    end
  end

  def destroy
    @deck.destroy
    respond_to do |format|
      format.html { redirect(decks_path, 'Deck was successfully deleted') }
      format.json { render json: nil, status: 204 }
    end
  end

  def search
    decks = if params[:term].present?
              Deck.where('name LIKE ?', "#{params[:term]}%").pluck(:name)
            else
              Deck.pluck(:name)
            end

    render json: decks
  end

  private

  def set_deck
    @deck = Deck.find_by(id: params[:id])
  end

  def deck_params
    params.require(:deck).permit(:name)
  end
end
