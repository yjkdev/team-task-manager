require "test_helper"

class Admin::TaskProgressReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_task_progress_reports_index_url
    assert_response :success
  end
end
