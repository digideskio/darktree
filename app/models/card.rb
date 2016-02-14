class Card < ActiveRecord::Base
  validates :head, presence: true, length: { maximum: 255 }
  validates :tail, presence: true, length: { maximum: 255 }
  validates :memo, length: { maximum: 5000 }
  validates :check, numericality: { only_integer: true, grater_than: 0 }
  validates :status, numericality: { only_integer: true} , inclusion: { in: 0..2 }
end
