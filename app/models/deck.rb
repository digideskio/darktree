class Deck < ActiveRecord::Base
  has_many :card_decks, dependent: :destroy
  has_many :cards, through: :card_decks

  validates :name, presence: true, length: { maximum: 255 }
end
