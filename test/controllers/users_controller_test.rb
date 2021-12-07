require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get availability" do
    post login_url,
      params: { email: "normal@vanderbilt.edu", password: 'password' }
    get users_availability_url
    assert_response :success
  end

  test "should not get availability when not logged in" do
    get users_availability_url
    assert_response :redirect
  end

  test "should get profile" do
    post login_url,
      params: { email: "normal@vanderbilt.edu", password: 'password' }
    get users_profile_url
    assert_response :success
  end

  test "should not get profile when not logged in" do
    get users_profile_url
    assert_response :redirect
  end

  test "should get check_in" do
    post login_url,
      params: { email: "normal@vanderbilt.edu", password: 'password' }
    get users_check_in_url
    assert_response :success
  end

  test "should not get check_in when not logged in" do
    get users_check_in_url
    assert_response :redirect
  end

  test "should get points" do
    post login_url,
      params: { email: "normal@vanderbilt.edu", password: 'password' }
    get users_points_url
    assert_response :success
  end

  test "should not get points when not logged in" do
    get users_points_url
    assert_response :redirect
  end

  test "should get subboard" do
    post login_url,
      params: { email: "normal@vanderbilt.edu", password: 'password' }
    get users_subboard_url
    assert_response :success
  end

  test "should not get subboard when not logged in" do
    get users_subboard_url
    assert_response :redirect
  end

  test "should signup user" do
    get signup_url
    assert_response :success
    post signup_url,
      params:  { user: { email: "test@vanderbilt.edu", password:"password" } }
    assert User.find_by_email("test@vanderbilt.edu")
    assert_not User.find_by_email("test@vanderbilt.edu").administrator
  end

  test "should error user email" do
    post signup_url,
      params: { user: { email: "test", password: "password" } }
    assert_not User.find_by_email("test")
  end

  test "should login user" do
    post login_url,
      params: { email: "normal@vanderbilt.edu", password: 'password' }
    assert session[:user_id] == User.find_by_email("normal@vanderbilt.edu").id
    get users_profile_url
    assert_response :success
  end

  test "should fail login" do
    post login_url,
      params: { email: "normal@vanderbilt.edu", password: "wrongpassword" }
    assert_not session[:user_id]
  end

  test "should get list for administrator" do
    post login_url,
      params: { email: "admin@vanderbilt.edu", password: "password" }
    get users_list_url
    assert_response :success
  end

  test "should not get list for non-administrator" do
    post login_url,
      params: { email: "normal@vanderbilt.edu", password: "password" }
    get users_list_url
    assert_response :redirect
  end

test "should not get list when not logged in" do
    get users_list_url
    assert_response :redirect
  end

end
