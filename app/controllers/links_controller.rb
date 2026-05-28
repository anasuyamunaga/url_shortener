class LinksController < ApplicationController
  before_action :set_link, only: [:show]

  # GET /
  def index
    @links = Link.recent.select(:id, :name, :target_url, :slug, :created_at)
    visit_counts = Visit.human
                        .where(link_id: @links.map(&:id))
                        .group(:link_id)
                        .count
    @click_counts = visit_counts
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # POST /links
  def create
    @link = Link.new(link_params)

    if @link.save
      redirect_to link_path(@link.slug), notice: "Short link created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /links/:slug
  def show
    @visits = @link.recent_visits(50).select(:id, :visited_at, :user_agent, :referrer, :ip_digest, :bot)
    @total_human_visits = @link.visits.human.count
  end

  private

  def set_link
    @link = Link.find_by!(slug: params[:slug])
  rescue ActiveRecord::RecordNotFound
    render file: Rails.root.join("public/404.html"), status: :not_found, layout: false
  end

  def link_params
    params.require(:link).permit(:name, :target_url, :slug)
  end
end
