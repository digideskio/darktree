class Deck < ActiveRecord::Base
  belongs_to :deck_source
  has_many :cards, dependent: :destroy
  validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :deck_source_id, presence: true, uniqueness: true
end
