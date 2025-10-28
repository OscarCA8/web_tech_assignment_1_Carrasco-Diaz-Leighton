class ProgressEntriesController < ApplicationController
  before_action :set_progress_entry, only: [:show, :edit, :update, :destroy]
  before_action :set_challenge, only: [:index, :new, :create]

  def index
    @progress_entries = if @challenge
                          @challenge.progress_entries.includes(:user).order(date: :desc)
                        else
                          ProgressEntry.includes(:user, :challenge).order(date: :desc)
                        end
  end

  def show
  end

  def new
    @progress_entry = @challenge.progress_entries.build
  end

  def create
    @progress_entry = @challenge.progress_entries.build(progress_entry_params.merge(user: current_user))
    if @progress_entry.save
      redirect_to challenge_progress_entries_path(@challenge), notice: "Progress logged."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @progress_entry.update(progress_entry_params)
      redirect_to progress_entry_path(@progress_entry), notice: "Progress entry updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @progress_entry.destroy
    redirect_back fallback_location: root_path, notice: "Progress entry deleted."
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:challenge_id]) if params[:challenge_id]
  end

  def set_progress_entry
    @progress_entry = ProgressEntry.find(params[:id])
  end

  def progress_entry_params
    params.require(:progress_entry).permit(:date, :points, :description)
  end
end