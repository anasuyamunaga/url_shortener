require "rails_helper"

RSpec.describe Link, type: :model do
  subject(:link) { build(:link) }

  it { is_expected.to have_many(:visits).dependent(:destroy) }

  it "accepts a valid https URL" do
    link.target_url = "https://example.com"
    expect(link).to be_valid
  end

  it "rejects a bare domain" do
    link.target_url = "example.com"
    expect(link).not_to be_valid
  end

  it "auto-generates a slug when none is provided" do
    link.slug = nil
    link.valid?
    expect(link.slug).to be_present
  end

  it "rejects a duplicate slug" do
    create(:link, slug: "taken")
    link = build(:link, slug: "taken")
    expect(link).not_to be_valid
    expect(link.errors[:slug]).to be_present
  end

  it "returns the correct total visit count" do
    link = create(:link)
    create_list(:visit, 3, link: link)
    expect(link.total_visits).to eq(3)
  end
end
