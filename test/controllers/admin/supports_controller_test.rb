require "test_helper"

class Admin::SupportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_supports_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_supports_show_url
    assert_response :success
  end

  test "should get update" do
    get admin_supports_update_url
    assert_response :success
  end
end
