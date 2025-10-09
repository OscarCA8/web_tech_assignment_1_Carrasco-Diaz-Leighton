class ChallengesController < ApplicationController
  def index
    @challenges = Challenge.all
  end

  def show
    @challenge = Challenge.find(params[:id])
    @participants = @challenge.participations.includes(:user)
    @badges = @challenge.badges
  end
end


