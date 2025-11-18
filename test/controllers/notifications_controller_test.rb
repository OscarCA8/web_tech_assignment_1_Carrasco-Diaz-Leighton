require "test_helper"
require "devise/test/integration_helpers"

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # We create data explicitly in setup for isolation from repo fixtures.

  def setup
    Notification.delete_all
    User.delete_all
    @user = User.create!(email: "notify_user@example.com", name: "Notify User", password: "password123", birthday: Date.new(1990,1,1), nationality: "X", gender: "O")
    @other = User.create!(email: "other_user@example.com", name: "Other User", password: "password123", birthday: Date.new(1990,1,1), nationality: "X", gender: "O")
  end

  test "should get index" do
    sign_in @user
    get notifications_path
    assert_response :success
  end

  test "show marks notification as read" do
    n = Notification.create!(user: @user, message: "Unread message", read: false)
    sign_in @user
    get notification_path(n)
    assert_response :success
    assert n.reload.read?, "Notification should be marked as read after show"
  end

  test "destroy removes the notification for owner" do
    n = Notification.create!(user: @user, message: "To be deleted", read: false)
    sign_in @user
    assert_difference "Notification.count", -1 do
      delete notification_path(n)
    end
    assert_redirected_to notifications_path
  end

  test "cannot destroy another users notification" do
    n = Notification.create!(user: @other, message: "Other user's notification", read: false)
    sign_in @user
    # Attempting to delete another user's notification should not remove it
    delete notification_path(n)
    assert Notification.exists?(n.id), "Other user's notification must remain"
  end

  test "mark_all_read marks all notifications as read" do
    Notification.create!(user: @user, message: "Message A", read: false)
    Notification.create!(user: @user, message: "Message B", read: false)
    sign_in @user
    patch mark_all_read_notifications_path
    assert_redirected_to notifications_path
    assert_equal 0, @user.notifications.where(read: false).count
  end
end
