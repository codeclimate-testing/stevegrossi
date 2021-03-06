class Post < ActiveRecord::Base

  paginates_per 20

  include Postable

  extend FriendlyId
  friendly_id :title

  include PgSearch
  multisearchable against: [:title, :idea, :content],
                  if: :published?

  belongs_to :book
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title,   presence: true
  validates :idea,    presence: true
  validates :content, presence: true

  before_validation :set_title_to_book_title
  before_save :set_word_count

  def set_title_to_book_title
    self.title = book.title if title.blank? && book_post?
  end

  scope :book_posts, -> { where.not(book_id: nil) }
  scope :link_posts, -> { where.not(link_url: nil).where.not(link_url: "") }
  scope :writing_posts, -> { where("link_url IS NULL OR link_url = ''").where(book_id: nil) }

  def book_post?
    book.present?
  end

  def count_words
    content.scan(/\S+/).size
  end

  def self.tagged_with(tag)
    tag.posts
  end

  def subtitle
    book.try(:subtitle)
  end

  def self.published_tag_counts
    Tag
      .select("tags.*, count(taggings.tag_id) as count")
      .joins(taggings: :post)
      .group([:id, :name, :slug])
      .where.not(posts: { published_at: nil })
  end

  private

  def set_word_count
    self.word_count = count_words
  end

end
