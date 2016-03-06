class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy, :fav]

  def index
    @cards = Card.status_is(params[:status]).tag_in(params[:tags])
                 .by_query(params[:query]).page(params[:page]).includes(:tags)
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
    if @card.update(card_params)
      redirect_to @card, notice: { success: 'Card was successfully updated.' }
    else
      format.html { render :edit }
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

  def fav
    render json: { msg: 'Not found' }, status: 400 and return if @card.nil?

    if @card.update(favorite: params[:fav])
      render json: @card
    else
      render json: @card.errors, status: 400
    end
  end

  private

  def set_card
    @card = Card.find_by(id: params[:id])
  end

  def card_params
    params.require(:card).permit(:head, :tail, :memo, :check, :status, :favorite, :tag_list)
  end

  def cards_params
    params.require(:cards).map do |c|
      c.permit([:head, :tail, :memo, :check, :stauts])
    end
  end
end
