class RedirectsController < ApplicationController
  def show
    link = Link.find_by(slug: params[:slug])

    if link.nil?
      render file: Rails.root.join("public/404.html"), status: :not_found, layout: false
      return
    end

    record_visit(link)

    redirect_to link.target_url, allow_other_host: true, status: :found
  end

  private

  def record_visit(link)
    return if request.head?

    ua       = request.user_agent.to_s.truncate(512)
    referrer = request.referrer.to_s.truncate(2048)
    is_bot   = Visit.bot_user_agent?(ua)
    ip        = request.remote_ip
    ip_digest = Digest::SHA256.hexdigest("#{link.id}:#{ip}:#{salt}")

    link.visits.create!(
      visited_at: Time.current,
      user_agent: ua,
      referrer:   referrer,
      ip_digest:  ip_digest,
      bot:        is_bot
    )
  rescue => e
    Rails.logger.error("[RedirectsController] visit recording failed: #{e.class}: #{e.message}")
  end

  def salt
    @salt ||= Date.current.to_s
  end
end
