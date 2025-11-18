class BadgesController < ApplicationController
  before_action :set_badge, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authorize_badge!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @badges = Badge.order(:name)
  end

  def show
    @challenges = @badge.challenges
    @users = @badge.users
  end

  def new
    @badge = Badge.new
  end

  def create
    @badge = Badge.new(badge_params)
    if @badge.save
      redirect_to @badge, notice: "Badge created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @badge.update(badge_params)
      redirect_to @badge, notice: "Badge updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @badge.destroy
    redirect_to badges_path, notice: "Badge deleted."
  end

  private

  def set_badge
    @badge = Badge.find(params[:id])
  end

  def badge_params
    params.require(:badge).permit(:name, :logo, :badge_type, :description, :requirement)
  end

  def authorize_badge!
    # For actions where @badge is present, authorize management; otherwise check class-level create
    if defined?(@badge) && @badge
      authorize! :manage, @badge
    else
      authorize! :create, Badge
    end
  end
end