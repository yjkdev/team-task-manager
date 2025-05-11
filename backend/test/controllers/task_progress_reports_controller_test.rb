require "test_helper"

class TaskProgressReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get task_progress_reports_index_url
    assert_response :success
  end
end
