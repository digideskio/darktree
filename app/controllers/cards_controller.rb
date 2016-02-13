class CardsController < ApplicationController
  def index
    @cards = Card.page(params[:page])
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(card_params)
    respond_to do |format|
      if @card.save
        format.html { redirect_to cards_path, notice: 'Card was successfully created.' }
        format.json { render json: @card, status: :create }
      else
        format.html { render action: 'new' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @card = Card.find(params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def card_params
    params.require(:card).permit(:head, :tail, :memo, :check, :status)
  end
end
