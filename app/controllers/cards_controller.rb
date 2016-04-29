class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy, :favorite, :unfavorite, :status]

  def index
    @cards = Card.status_is(params[:status]).deck_in(params[:deck])
                 .by_query(params[:query]).sort_by(params[:sort])
                 .by_fav(params[:fav]).page(params[:page]).includes(:decks).order(id: :asc)
    @decks = Deck.select(:name)
  end

  def show
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(card_params)
    if @card.save
      redirect_to cards_path, notice: { success: 'Card was successfully created.' }
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    redirect_to cards_path and return if @card.nil?

    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to @card, notice: { success: 'Card was successfully updated.' } }
        format.json { render json: @card }
      else
        format.html { render :edit }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @card.destroy
    redirect_to cards_path, notice: { success: 'Card was successfully deleted.' }
  end

  def confirm
    @new_cards = []

    if params[:file].present?
      CSV.foreach(params[:file].path, headers: true) do |row|
        card = Card.new(row.to_hash)
        @new_cards << card if card.valid?
      end
    end

    redirect_to new_card_path if @new_cards.blank?
  end

  def import
    cards = []
    cards_params.each do |param|
      cards << Card.new(param)
    end

    Card.transaction do
      cards.each(&:save!)
    end

    redirect_to cards_path, notice: { success: 'Cards were successfully imported.' }
  end

  private

  def set_card
    @card = Card.find_by(id: params[:id])
  end

  def card_params
    params.require(:card).permit(:front, :back, :memo, :check, :status, :favorite, :check_count, :deck_list)
  end

  def cards_params
    params.require(:cards).map do |c|
      c.permit([:front, :back, :memo, :check, :favorite, :check_count, :status, :deck_list])
    end
  end
end
