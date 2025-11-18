class ChallengesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_challenge, only: [:show, :edit, :update, :destroy, :join, :leave]
  before_action :authorize_challenge!, only: [:edit, :update, :destroy]
  before_action :authorize_challenge_create, only: [:new, :create]
  
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
    redirect_to new_participation_path(challenge_id: @challenge.id)
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

  def authorize_challenge!
    authorize! :manage, @challenge
  end

  def authorize_challenge_create
    authorize! :create, Challenge
  end
end