class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :toggle_admin]
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  before_action :authorize_users_index, only: [:index]

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
    attrs = user_params.to_h
    if attrs['password'].blank?
      attrs.delete('password')
    end

    if @user.update(attrs)
      if @user == current_user
        bypass_sign_in(@user)
      end
      redirect_to @user, notice: "Profile updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "User removed."
  end

  def toggle_admin
    # Only admins may toggle admin status.
    unless current_user&.is_admin?
      raise CanCan::AccessDenied.new("Not authorized", :manage, User)
    end
    # Flip the is_admin boolean
    @user.is_admin = !@user.is_admin?
    if @user.save
      redirect_back fallback_location: users_path, notice: "User admin status updated."
    else
      redirect_back fallback_location: users_path, alert: "Could not update admin status: #{@user.errors.full_messages.join(', ')}"
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    permitted = [:name, :password, :birthday, :nationality, :gender]
    permitted << :is_admin if current_user && current_user.is_admin?
    params.require(:user).permit(permitted)
  end

  def authorize_user!
    authorize! :manage, @user
  end

  def authorize_users_index
    authorize! :read, User
  end
end