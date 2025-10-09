require "test_helper"

class ProgressEntriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get progress_entries_index_url
    assert_response :success
  end

  test "should get show" do
    get progress_entries_show_url
    assert_response :success
  end
end
