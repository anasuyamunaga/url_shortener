require "rails_helper"

RSpec.describe Visit, type: :model do
  it { is_expected.to belong_to(:link) }

  it "flags Googlebot as a bot" do
    expect(Visit.bot_user_agent?("Googlebot/2.1")).to be true
  end

  it "flags Slack previewer as a bot" do
    expect(Visit.bot_user_agent?("Slackbot-LinkExpanding 1.0")).to be true
  end

  it "flags blank user agent as a bot" do
    expect(Visit.bot_user_agent?("")).to be true
  end

  it "does not flag a normal browser as a bot" do
    expect(Visit.bot_user_agent?("Mozilla/5.0 Chrome/123.0")).to be false
  end

  it ".human excludes bot visits" do
    human = create(:visit, bot: false)
    _bot  = create(:visit, :bot)
    expect(Visit.human).to contain_exactly(human)
  end
end