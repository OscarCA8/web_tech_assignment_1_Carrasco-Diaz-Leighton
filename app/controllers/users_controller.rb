class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.order(:name)
  end

  def show
    @participations = @user.participations.includes(:challenge)
    @user_badges = @user.user_badges.includes(:badge)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "Account created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Profile updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "User removed."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :password, :birthday, :nationality, :gender, :is_admin)
  end
end