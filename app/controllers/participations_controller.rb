class ParticipationsController < ApplicationController
  before_action :set_participation, only: [:show, :edit, :update, :destroy]
  before_action :set_users_and_challenges, only: [:new, :edit, :create, :update]

  def index
    @participations = Participation.all.includes(:user, :challenge)
  end

  def show
  end

  def new
    @participation = Participation.new
  end

  def create
    @participation = Participation.new(participation_params)
    if @participation.save
      redirect_to participations_path, notice: "Participation successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @participation.update(participation_params)
      redirect_to participation_path(@participation), notice: "Participation updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @participation.destroy
      redirect_to participations_path, notice: "Participation removed."
    else
      redirect_to participations_path, alert: "Could not remove participation: #{@participation.errors.full_messages.join(', ')}"
    end
  end

  private

  def set_participation
    @participation = Participation.find(params[:id])
  end

  def set_users_and_challenges
    @users = User.all
    @challenges = Challenge.all
  end

  def participation_params
    params.require(:participation).permit(:user_id, :challenge_id, :points, :date_start)
  end
end
