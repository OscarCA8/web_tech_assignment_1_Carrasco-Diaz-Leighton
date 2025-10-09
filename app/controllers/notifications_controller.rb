class NotificationsController < ApplicationController
  def index
    @notifications = Notification.order(created_at: :desc)
  end

  def show
    @notification = Notification.find(params[:id])
  end
end

