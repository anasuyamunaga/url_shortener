module ApplicationHelper
  # Generates the full public redirect URL for a given slug.
  # Using a named helper keeps views decoupled from the route name.
  def redirect_url(slug)
    redirect_url_for(slug)
  end

  private

  def redirect_url_for(slug)
    # `redirect_path` is the Rails named route; we want the full URL for display.
    url_for(controller: "redirects", action: "show", slug: slug, only_path: false)
  end
end
