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

  test "should signup user" do
    get signup_url
    assert_response :success
    post signup_url,
      params:  { user: { email: "test@mail.com", password:"password" } }
    assert User.find_by_email("test@mail.com")
    assert_not User.find_by_email("test@mail.com").administrator
  end

  test "should error user" do
    post signup_url,
      params: { user: { email: "test", password: "password" } }
    assert_not User.find_by_email("test")
  end

  test "should login user" do
    post login_url,
      params: { email: "normal@mail.com", password: 'password' }
    assert session[:user_id] == User.find_by_email("normal@mail.com").id
    get users_profile_url
    assert_response :success
  end

  test "should fail login" do
    post login_url,
      params: { email: "normal@mail.com", password: "wrongpassword" }
    assert_not session[:user_id]
  end

  test "should get list for administrator" do
    
  end

end
