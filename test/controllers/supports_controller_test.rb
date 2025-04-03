require "test_helper"

class SupportsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get supports_new_url
    assert_response :success
  end

  test "should get create" do
    get supports_create_url
    assert_response :success
  end
end
