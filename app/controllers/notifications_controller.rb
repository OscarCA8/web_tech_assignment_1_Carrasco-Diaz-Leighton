class NotificationsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @notifications = Notification.all.order(created_at: :desc)
  end

  def show
    @notification = Notification.find(params[:id])
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
    redirect_to notifications_path, notice: "Notification deleted."
  end
end