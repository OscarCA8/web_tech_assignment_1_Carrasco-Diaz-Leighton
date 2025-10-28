class ChallengesController < ApplicationController
  before_action :set_challenge, only: [:show, :edit, :update, :destroy, :join, :leave]

  def index
    @challenges = if params[:query].present?
                    Challenge.where("name ILIKE ?", "%#{params[:query]}%").includes(:creator)
                  else
                    Challenge.includes(:creator).order(start_day: :desc)
                  end
  end

  def show
    @participants = @challenge.participations.includes(:user).order(points: :desc)
    @badges = @challenge.badges
    @recent_entries = @challenge.progress_entries.includes(:user).order(date: :desc).limit(10)
  end

  def new
    @challenge = Challenge.new
  end

  def create
    @challenge = current_user.created_challenges.build(challenge_params)
    if @challenge.save
      redirect_to @challenge, notice: "Challenge created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @challenge.update(challenge_params)
      redirect_to @challenge, notice: "Challenge updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @challenge.destroy
    redirect_to challenges_path, notice: "Challenge deleted."
  end

  def join
    unless current_user && @challenge.users.exists?(current_user.id)
      Participation.create!(user: current_user, challenge: @challenge, date_start: Date.today, points: 0)
      redirect_to @challenge, notice: "Joined challenge."
    else
      redirect_to @challenge, alert: "Already participating."
    end
  end

  def leave
    participation = Participation.find_by(user: current_user, challenge: @challenge)
    if participation
      participation.destroy
      redirect_to challenges_path, notice: "Left the challenge."
    else
      redirect_to @challenge, alert: "You are not a participant."
    end
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:id])
  end

  def challenge_params
    params.require(:challenge).permit(:name, :description, :start_day, :end_day, :point_rules)
  end
end