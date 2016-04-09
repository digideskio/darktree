class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy, :favorite, :unfavorite, :status]

  def index
    @cards = Card.status_is(params[:status]).tag_in(params[:tags])
                 .by_query(params[:query]).sort_by(params[:sort])
                 .by_fav(params[:fav]).page(params[:page]).includes(:tags)
    @tags = Tag.select(:name)
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
    @invalid_rows = []

    CSV.foreach(params[:file].path, headers: true) do |row|
      card = Card.new(row.to_hash)
      if card.valid?
        @new_cards << card
      else
        @invalid_rows << card
      end
    end

    format.html { render action: 'new', notice: { error: 'No valid cards' } } if @new_cards.empty?
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
    params.require(:card).permit(:front, :back, :memo, :check, :status, :favorite, :check_count, :tag_list)
  end

  def cards_params
    params.require(:cards).map do |c|
      c.permit([:front, :back, :memo, :check, :favorite, :check_count, :stauts])
    end
  end
end
