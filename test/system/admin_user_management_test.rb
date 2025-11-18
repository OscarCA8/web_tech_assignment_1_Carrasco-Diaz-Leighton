require "application_system_test_case"

class AdminUserManagementTest < ApplicationSystemTestCase
  def setup
    User.delete_all
    @admin = User.create!(email: "admin_test@example.com", name: "Admin Test", password: "password123", birthday: Date.new(1980,1,1), nationality: "X", gender: "O", is_admin: true)
    @user  = User.create!(email: "user_test@example.com", name: "User Test", password: "password123", birthday: Date.new(1990,1,1), nationality: "X", gender: "O", is_admin: false)
  end

  test "admin can see toggle and change user's admin status" do
    visit new_user_session_path
    fill_in "Email", with: @admin.email
    fill_in "Password", with: "password123"
    click_button "Sign in"

    visit users_path
    assert_selector "button", text: "Make Admin"

    # Click make admin for the regular user (find row)
    within(:xpath, "//tr[td[contains(.,'#{@user.name}')]]") do
      click_button "Make Admin"
    end

    assert_text "User admin status updated."
    @user.reload
    assert @user.is_admin?
  end

  test "regular user does not see the toggle" do
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "password123"
    click_button "Sign in"

    visit users_path
    assert_no_selector "button", text: "Make Admin"
  end
end
