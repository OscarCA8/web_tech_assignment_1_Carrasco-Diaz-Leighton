class ParticipationsController < ApplicationController
  before_action :set_participation, only: [:show, :edit, :update, :destroy]
  before_action :set_users_and_challenges, only: [:new, :edit, :create, :update]
  before_action :authenticate_user!
  before_action :authorize_participation!, only: [:edit, :update, :destroy]
  before_action :authorize_participation_create, only: [:new, :create]

  def index
    @participations = Participation.all.includes(:user, :challenge)
  end

  def show
  end

  def new
    @participation = Participation.new
    if params[:challenge_id].present?
      @participation.challenge = Challenge.find(params[:challenge_id])
    end

    @participation.user = current_user
  end

  def create
    @participation = Participation.new(participation_params)

    ActiveRecord::Base.transaction do
      if @participation.save
        # create an initial progress entry for this participant on their start date
        pe = ProgressEntry.new(
          user: @participation.user,
          challenge: @participation.challenge,
          date: @participation.date_start,
          points: @participation.points,
          description: "Joined challenge"
        )

        unless pe.save
          # surface progress entry validation errors on the participation form
          pe.errors.full_messages.each { |m| @participation.errors.add(:base, "Progress entry: #{m}") }
          raise ActiveRecord::Rollback
        end

        redirect_to challenge_path(@participation.challenge), notice: "Participation created and progress entry added."
        return
      else
        render :new, status: :unprocessable_entity
        return
      end
    end

    # If we reach here the transaction was rolled back due to progress entry errors
    render :new, status: :unprocessable_entity
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

  def authorize_participation!
    authorize! :manage, @participation
  end

  def authorize_participation_create
    authorize! :create, Participation
  end
end
