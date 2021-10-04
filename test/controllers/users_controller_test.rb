require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get availability" do
    get users_availability_url
    assert_response :success
  end

  test "should get profile" do
    get users_profile_url
    assert_response :success
  end
end
