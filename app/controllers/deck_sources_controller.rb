class DeckSourcesController < ApplicationController
  def index
    @deck_src = DeckSource.new
    @deck_srcs = DeckSource.all
  end

  def create
    @deck_src = DeckSource.new(deck_src_params)

    respond_to do |format|
      if @deck_src.save
        format.html { redirect_to(deck_sources_url, notice: { success: 'Deck source was successfully created'}) }
        format.json { render json: @deck_src }
      else
        format.html { render action: 'new' }
        format.json { render json: @deck_src.errors, status: 400 }
      end
    end
  end

  private

  def deck_src_params
    params.require(:deck_source).permit(:deck_name, :url)
  end
end
