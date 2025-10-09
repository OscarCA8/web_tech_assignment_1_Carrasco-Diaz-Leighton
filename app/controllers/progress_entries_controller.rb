class ProgressEntriesController < ApplicationController
  def index
    @progress_entries = ProgressEntry.includes(:user, :challenge)
  end

  def show
    @progress_entry = ProgressEntry.find(params[:id])
  end
end

