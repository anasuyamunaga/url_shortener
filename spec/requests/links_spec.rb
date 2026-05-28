require "rails_helper"

RSpec.describe "Links", type: :request do
  describe "GET /" do
    it "returns 200" do
      get "/"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /links" do
    it "creates a link and redirects to detail page" do
      expect {
        post links_path, params: { link: { target_url: "https://example.com", name: "Test" } }
      }.to change(Link, :count).by(1)
      expect(response).to redirect_to(link_path(Link.last.slug))
    end

    it "renders form errors for an invalid URL" do
      post links_path, params: { link: { target_url: "not-a-url" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "rejects a duplicate custom slug" do
      create(:link, slug: "taken")
      post links_path, params: { link: { target_url: "https://example.com", slug: "taken" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /links/:slug" do
    it "returns 200" do
      link = create(:link)
      get link_path(link.slug)
      expect(response).to have_http_status(:ok)
    end

    it "returns 404 for unknown slug" do
      get link_path("noexist")
      expect(response).to have_http_status(:not_found)
    end
  end
end
