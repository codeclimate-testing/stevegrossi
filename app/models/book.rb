# == Schema Information
#
# Table name: books
#
#  id           :integer         not null, primary key
#  title        :string(255)
#  publisher    :string(255)
#  pub_year     :string(255)
#  asin         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  subtitle     :string(255)
#  cover_image  :string(255)
#  published_at :datetime
#  slug         :string(255)
#  read_on      :date
#

class Book < ActiveRecord::Base

  extend FriendlyId
  friendly_id :title

  attr_accessible :title, :subtitle, :asin, :publisher, :pub_year, :thesis, :thoughts, :author_ids, :cover_image, :published_at, :read_on

  include Postable

  has_one :post
  has_many :authorships, dependent: :destroy
  has_many :authors, through: :authorships

  validates :title,     presence: true
  validates :publisher, presence: true
  validates :pub_year,  presence: true
  validates :thoughts,  presence: true
  validates :authors,   presence: true
  validates :read_on,   presence: true

end
