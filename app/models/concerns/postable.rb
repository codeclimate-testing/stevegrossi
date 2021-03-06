module Postable

  extend ActiveSupport::Concern

  included do
    scope :published, -> { where.not(published_at: nil).order(published_at: :desc) }
    scope :drafts, -> { where(published_at: nil) }
  end

  def previous
    self.class.published.find_by("created_at < ?", created_at)
  end

  def next
    self.class.published.where("created_at > ?", created_at).last
  end

  def draft?
    published_at.nil?
  end

  def published?
    !draft?
  end

  def pretty_published_at
    published_at.nil? ? "Unpublished" : published_at.strftime("%B %-e, %Y")
  end
end
