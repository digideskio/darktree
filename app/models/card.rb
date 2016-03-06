class Card < ActiveRecord::Base
  STATUSES = {
    0 => 'Bad',
    1 => 'Almost',
    2 => 'Good'
  }

  SORT_OPTIONS = {
    'updated_at-asc' => 'Last modified: Old to New',
    'updated_at-desc' => 'Last modified: New to Old',
  }

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  accepts_nested_attributes_for :tags
  attr_accessor :tag_list

  validates :head, presence: true, length: { maximum: 5000 }
  validates :tail, presence: true, length: { maximum: 5000 }
  validates :memo, length: { maximum: 5000 }
  validates :status, numericality: { only_integer: true }, inclusion: { in: 0..2 }
  validates :favorite, inclusion: { in: [true, false] }

  scope :by_query, lambda { |query|
    if query.present?
      where('head LIKE ? or tail LIKE ?', "%#{query}%", "%#{query}%")
    end
  }

  scope :status_is, lambda { |status|
    where(status: status) if status.present?
  }

  scope :tag_in, lambda { |tags|
    joins(:tags).where(tags: { name: Array(tags) }) if tags.present?
  }

  scope :sort_by, lambda { |sort_opt|
    return unless SORT_OPTIONS.has_key?(sort_opt)
    column, order = sort_opt.split("-")
    order(column => order.to_sym, id: :asc)
  }

  before_create do
    # カンマ区切りで渡されるタグを登録
    # 存在しないタグの場合は新規作成
    if tag_list.present?
      tag_list.split(',').each do |tag_name|
        tags << Tag.where(name: tag_name).first_or_initialize if tag_name.present?
      end
    end
  end

  before_update do
    taggings.each(&:destroy)
    if tag_list.present?
      tag_list.split(',').each do |tag_name|
        tags << Tag.where(name: tag_name).first_or_initialize if tag_name.present?
      end
    end
  end
end
