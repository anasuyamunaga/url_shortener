class Visit < ApplicationRecord
  belongs_to :link

  # Known bot/preview user-agent substrings (case-insensitive).
  # We store the visit record but mark it so the detail view can show it
  # and operators can decide to exclude it from counts if desired.
  # Keeping bot visits in the DB gives us audit trail; filtering them out
  # at query time is the safer default for analytics accuracy.
  BOT_PATTERNS = %w[
    Googlebot Bingbot Slurp DuckDuckBot Baiduspider YandexBot
    facebookexternalhit Twitterbot LinkedInBot WhatsApp Slack
    Discordbot Telegrambot iMessage TelegramBot Applebot
    preview curl wget python-requests Go-http-client HeadlessChrome
  ].freeze

  BOT_REGEX = Regexp.union(BOT_PATTERNS.map { |p| /#{Regexp.escape(p)}/i }).freeze

  scope :human, -> { where(bot: false) }
  scope :recent, -> { order(visited_at: :desc) }

  def self.bot_user_agent?(ua)
    return true if ua.blank?
    BOT_REGEX.match?(ua)
  end
end
