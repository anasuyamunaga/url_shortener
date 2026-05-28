class Link < ApplicationRecord
  has_many :visits, dependent: :destroy

  SLUG_ALPHABET = ("a".."z").to_a + ("0".."9").to_a
  SLUG_LENGTH   = 6
  MAX_SLUG_RETRIES = 10

  validates :target_url, presence: true, format: {
    with: /\Ahttps?:\/\/.+/i,
    message: "must start with http:// or https://"
  }
  validates :slug, presence: true, uniqueness: { case_sensitive: false },
                   format: {
                     with: /\A[a-z0-9\-_]+\z/i,
                     message: "may only contain letters, numbers, hyphens, and underscores"
                   },
                   length: { minimum: 2, maximum: 64 }
  validates :name, length: { maximum: 255 }

  before_validation :assign_slug, if: -> { slug.blank? }
  before_validation :strip_whitespace

  scope :recent, -> { order(created_at: :desc) }

  def total_visits
    visits.count
  end

  def recent_visits(limit = 50)
    visits.order(visited_at: :desc).limit(limit)
  end

  private

  def assign_slug
    MAX_SLUG_RETRIES.times do
      candidate = generate_slug
      unless Link.exists?(slug: candidate)
        self.slug = candidate
        return
      end
    end
    self.slug = generate_slug(SLUG_LENGTH + 4)
  end

  def generate_slug(length = SLUG_LENGTH)
    Array.new(length) { SLUG_ALPHABET.sample }.join
  end

  def strip_whitespace
    self.target_url = target_url&.strip
    self.name       = name&.strip
    self.slug       = slug&.strip&.downcase
  end
end
