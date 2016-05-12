class Deck < ActiveRecord::Base
  has_many :cards, dependent: :destroy
  validates :name, presence: true, length: { maximum: 255 }
end
