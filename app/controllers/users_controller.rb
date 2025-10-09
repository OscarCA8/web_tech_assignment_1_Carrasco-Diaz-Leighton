class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @participations = @user.participations.includes(:challenge)
    @badges = @user.badges
  end
end

