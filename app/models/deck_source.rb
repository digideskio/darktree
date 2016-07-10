class DeckSource < ActiveRecord::Base
  has_one :deck
  validates :deck_name, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :url, presence: true, length: { maximum: 255 }
end
