class DecksController < ApplicationController
  before_action :set_deck, only: [:update, :destroy, :show]

  def index
    @decks = Deck.all.order(id: :desc)
    respond_to do |format|
      format.html
      format.json { render json: @decks }
    end
  end

  def show
    respond_to do |format|
      format.json { render json: @deck }
    end
  end

  def create
    @deck = Deck.new(deck_params)

    respond_to do |format|
      if @deck.save
        format.json { render json: @deck }
      else
        format.json { render json: @deck.errors, status: 400 }
      end
    end
  end

  def update
    redirect_to root_path and return if @deck.nil?

    respond_to do |format|
      if @deck.update(deck_params)
        format.json { render json: @deck }
      else
        format.json { render json: @deck.errors, status: 400 }
      end
    end
  end

  def destroy
    @deck.destroy
    respond_to do |format|
      format.html { redirect_to(decks_path, notice: { success: 'Deck was successfully deleted'}) }
      format.json { render json: nil, status: 204 }
    end
  end

  def import
    # nilがありうる
    deck_src = DeckSource.find_by(id: params[:id])

    # exception: URI::InvalidURIError
    uri = URI.parse(deck_src.url)

    # 1. fetch resource
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    response = http.start do
      http.get(uri.path)
    end

    response.value unless response.is_a?(Net::HTTPSuccess)

    # 200 or others

    # 2. import
    ActiveRecord::Base.transaction do
      # find
      deck = Deck.where(name: deck_src.deck_name).first_or_initialize

      # remove cards
      Card.where(deck_id: deck.id).each(&:destroy!)

      # re-import
      CSV.parse(response.body.force_encoding('UTF-8'), headers: true, skip_blanks: true) do |row|
        deck.cards << Card.new(deck_name: deck_src.deck_name, front: row['front'], back: row['back'])
      end
      deck.save!
    end

    redirect_to root_path, notice: { success: 'ok' }
  rescue URI::InvalidURIError => e
    "#{e.class}"
  rescue Net::HTTPExceptions => e
    "HTTP_REQUEST FAILED: #{e.class}"
  rescue Timeout::Error => e
    "TIMEOUT: #{e.class}"
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
    @deck = Deck.find_by(id: params[:id]) || {}
  end

  def deck_params
    params.require(:deck).permit(:name)
  end
end
