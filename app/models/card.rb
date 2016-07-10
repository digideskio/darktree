class Card < ActiveRecord::Base
  # TODO: ヘルパーに書いた方が良さそう？
  SORT_OPTIONS = {
    'updated_at-asc' => 'Last modified: Old to New',
    'updated_at-desc' => 'Last modified: New to Old'
  }.freeze

  belongs_to :deck

  attr_accessor :deck_name

  validates :front, presence: true, length: { maximum: 5000 }
  validates :back, presence: true, length: { maximum: 5000 }
  validates :check_count, numericality: { only_integer: true }
  validates :status, inclusion: { in: [true, false] }
  validates :favorite, inclusion: { in: [true, false] }

  scope :by_query, lambda { |query|
    if query.present?
      where('front LIKE ? or back LIKE ?', "%#{query}%", "%#{query}%")
    end
  }

  scope :status_is, lambda { |status|
    if status == '1'
      where(status: true)
    elsif status == '0'
      where(status: false)
    end
  }

  scope :fav_is, lambda { |fav|
    if fav == '1'
      where(favorite: true)
    elsif fav == '0'
      where(favorite: false)
    end
  }

  scope :deck_is, lambda { |deck_id|
    joins(:deck).where(decks: { id: deck_id }) if deck_id.present?
  }

  scope :sort_by, lambda { |sort_opt|
    return unless SORT_OPTIONS.key?(sort_opt)
    column, order = sort_opt.split('-')
    order(column => order.to_sym, id: :asc)
  }

  before_save do
    if Deck.exists?(name: deck_name)
      self.deck = Deck.find_by(name: deck_name)
    else
      self.deck = Deck.create(name: deck_name)
    end
  end
end
