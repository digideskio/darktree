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

  def destroy
    @deck_src = DeckSource.find_by(id: params[:id]) || {}
    @deck_src.destroy
    respond_to do |format|
      format.html { redirect_to(deck_sources_path, notice: { success: 'DeckSource was successfully deleted'}) }
      format.json { render json: nil, status: 204 }
    end
  end

  private

  def deck_src_params
    params.require(:deck_source).permit(:deck_name, :url)
  end
end
