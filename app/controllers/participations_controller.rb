class ParticipationsController < ApplicationController
  def index
    @participations = Participation.includes(:user, :challenge)
  end
end
