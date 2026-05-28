class CreateVisits < ActiveRecord::Migration[8.0]
  def change
    create_table :visits do |t|
      t.references :link, null: false, foreign_key: true
      t.datetime   :visited_at, null: false
      t.string     :user_agent, limit: 512
      t.string     :referrer,   limit: 2048
      t.string     :ip_digest,  limit: 64   # SHA-256 hex = 64 chars; no raw IPs stored
      t.boolean    :bot,        null: false, default: false
    end

    # Most common query: visits for a link, newest first, excluding bots
    add_index :visits, %i[link_id bot visited_at]
  end
end
