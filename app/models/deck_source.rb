class DeckSource < ActiveRecord::Base
  belongs_to :deck
  validates :deck_name, presence: true, length: { maximum: 255 }
  validates :url, presence: true, length: { maximum: 255 }
end
