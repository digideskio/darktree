class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  def edit; end

  def index
    # FIXME: 何かが良くない気がする
    @cards = Card.deck_is(params[:deck_id]).status_is(params[:status])
                 .fav_is(params[:fav]).sort_by(params[:sort]).page(params[:page]).order(id: :asc)
    @deck = Deck.find_by(id: params[:deck_id])

    respond_to do |format|
      format.html
      format.json { render json: @cards }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @card }
    end
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(card_params)

    respond_to do |format|
      if @card.save
        format.html { redirect(deck_cards_path(@card.deck.id), success_msg(:create)) }
        format.json { render json: @card }
      else
        format.html { render action: 'new' }
        format.json { render json: @card.errors, status: 400 }
      end
    end
  end

  def update
    redirect_to root_path and return if @card.nil?

    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect(deck_cards_path(@card.deck.id), success_msg(:update)) }
        format.json { render json: @card }
      else
        format.html { render :edit }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @card.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: { success: success_msg(:destroy) } }
      format.json { render json: nil, status: 204 }
    end
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

    redirect_to root_path, notice: { success: success_msg(:import) }
  end

  private

  def set_card
    @card = Card.find_by(id: params[:id]) || {}
  end

  def success_msg(type)
    case type
    when :create
      'Card was successfully created'
    when :update
      'Card was successfully updated'
    when :destroy
      'Card was successfully deleted'
    when :import
      'Cards were successfully imported'
    end
  end

  def redirect(path, message)
    redirect_to path, notice: { success: message }
  end

  def card_params
    params.require(:card).permit(:front, :back, :status, :favorite, :check_count, :deck_name, :deck_id)
  end

  def cards_params
    params.require(:cards).map do |c|
      c.permit([:front, :back, :status, :favorite, :check_count, :deck_name, :deck_id])
    end
  end
end
