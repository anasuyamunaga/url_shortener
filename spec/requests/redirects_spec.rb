require "rails_helper"

RSpec.describe "Redirects", type: :request do
  let!(:link) { create(:link, target_url: "https://example.com", slug: "testme") }

  it "redirects to the target URL with 302" do
    get "/r/testme"
    expect(response).to redirect_to("https://example.com")
    expect(response).to have_http_status(:found)
  end

  it "records a visit" do
    expect { get "/r/testme" }.to change(Visit, :count).by(1)
  end

  it "flags bot user agents" do
    get "/r/testme", headers: { "User-Agent" => "Googlebot/2.1" }
    expect(Visit.last.bot).to be true
  end

  it "does not record HEAD requests" do
    expect { head "/r/testme" }.not_to change(Visit, :count)
  end

  it "returns 404 for unknown slug" do
    get "/r/doesnotexist"
    expect(response).to have_http_status(:not_found)
  end
end
