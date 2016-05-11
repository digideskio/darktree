class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  def index
    # FIXME: 何かが良くない気がする
    @cards = Card.deck_is(params[:deck_id]).status_is(params[:status]).fav_is(params[:fav])
                 .sort_by(params[:sort]).page(params[:page]).includes(:decks).order(id: :asc)
    @deck = Deck.find_by(id: params[:deck_id])
  end

  def show
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(card_params)
    if @card.save
      if @card.decks.first.present?
        redirect(deck_cards_path(@card.decks.first.id), success_msg(:create))
      else
        redirect(root_path, success_msg(:create))
      end
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    redirect_to root_path and return if @card.nil?

    respond_to do |format|
      if @card.update(card_params)
        format.html do
          if @card.decks.first.present?
            redirect(deck_cards_path(@card.decks.first.id), success_msg(:update))
          else
            redirect(root_path, success_msg(:update))
          end
        end
        format.json { render json: @card }
      else
        format.html { render :edit }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @card.destroy
    redirect_to root_path, notice: { success: success_msg(:destroy) }
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
    @card = Card.find_by(id: params[:id])
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
    params.require(:card).permit(:front, :back, :status, :favorite, :check_count, :deck_list)
  end

  def cards_params
    params.require(:cards).map do |c|
      c.permit([:front, :back, :status, :favorite, :check_count, :deck_list])
    end
  end
end
