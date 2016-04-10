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

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  accepts_nested_attributes_for :tags
  attr_accessor :tag_list

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

  scope :tag_in, lambda { |tags|
    joins(:tags).where(tags: { name: Array(tags) }) if tags.present?
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
    # Tagが既に存在する & Taggingに存在しない -> Taggingのみ新規登録
    # Tagが存在しない場合 -> Tag新規作成, Tagging新規登録
    if tag_list.present?
      taggings.each(&:destroy)
      tag_list.split(',').each do |tag_name|
        next unless tag_name.present?

        if Tag.exists?(name: tag_name)
          tag = Tag.find_by(name: tag_name)
          unless Tagging.exists?(card_id: id, tag_id: tag.id)
            tags << tag
          end
        else
          tags << Tag.new(name: tag_name)
        end
      end
    end
  end
end
