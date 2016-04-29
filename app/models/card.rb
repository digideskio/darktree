class Card < ActiveRecord::Base
  STATUSES = {
    0 => 'Bad',
    1 => 'Almost',
    2 => 'Good'
  }.freeze

  SORT_OPTIONS = {
    'updated_at-asc' => 'Last modified: Old to New',
    'updated_at-desc' => 'Last modified: New to Old'
  }.freeze

  has_many :card_decks, dependent: :destroy
  has_many :decks, through: :card_decks

  accepts_nested_attributes_for :decks
  attr_accessor :deck_list

  validates :front, presence: true, length: { maximum: 5000 }
  validates :back, presence: true, length: { maximum: 5000 }
  validates :memo, length: { maximum: 5000 }
  validates :status, numericality: { only_integer: true }, inclusion: { in: 0..2 }
  validates :check_count, numericality: { only_integer: true }
  validates :favorite, inclusion: { in: [true, false] }

  scope :by_query, lambda { |query|
    if query.present?
      where('front LIKE ? or back LIKE ?', "%#{query}%", "%#{query}%")
    end
  }

  scope :status_is, lambda { |status|
    where(status: status) if status.present?
  }

  scope :deck_in, lambda { |decks|
    joins(:decks).where(decks: { name: Array(decks) }) if decks.present?
  }

  scope :sort_by, lambda { |sort_opt|
    return unless SORT_OPTIONS.key?(sort_opt)
    column, order = sort_opt.split('-')
    order(column => order.to_sym, id: :asc)
  }

  scope :by_fav, lambda { |fav|
    if fav == '1'
      where(favorite: true)
    elsif fav == '0'
      where(favorite: false)
    end
  }

  before_save do
    # カンマ区切りで渡されるタグを登録
    # Deckが既に存在する & CardDeckに存在しない -> CardDeckのみ新規登録
    # Deckが存在しない場合 -> Deck新規作成, CardDeck新規登録
    if deck_list.present?
      card_decks.each(&:destroy)
      deck_list.split(',').each do |deck_name|
        next unless deck_name.present?

        if Deck.exists?(name: deck_name)
          deck = Deck.find_by(name: deck_name)
          unless CardDeck.exists?(card_id: id, deck_id: deck.id)
            decks << deck
          end
        else
          decks << Deck.new(name: deck_name)
        end
      end
    end
  end
end
