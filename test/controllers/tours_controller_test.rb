require "test_helper"

class ToursControllerTest < ActionDispatch::IntegrationTest
  test "should get new tour" do
    post login_url,
      params: { email: "admin@vanderbilt.edu", password: 'password' }
    get tours_new_url
    assert_response :success
  end

  test "should not get new tour for non-administrator" do
    post login_url,
      params: { email: "normal@vanderbilt.edu", password: 'password' }
    get tours_new_url
    assert_response :redirect
  end

  test "should not get new tour when not logged in" do
    get tours_new_url
    assert_response :redirect
  end

  test "should get tour manager" do
    post login_url,
      params: { email: "admin@vanderbilt.edu", password: 'password' }
    get tours_manage_url
    assert_response :success
  end

  test "should not get tour manager for non-administrator" do
    post login_url,
      params: { email: "normal@vanderbilt.edu", password: 'password' }
    get tours_manage_url
    assert_response :redirect
  end

  test "should not get tour manager when not logged in" do
    get tours_manage_url
    assert_response :redirect
  end

  test "should create new tour" do
    post login_url,
      params: { email: "admin@vanderbilt.edu", password: 'password' }
    post tours_create_url,
      params:  { tour: { time: "2022-02-11T16:31", hours: 1, min_guides: 5, location: "HOG", note: "testing", weekly: 0 } }
    assert Tour.find_by_time("2022-02-11T16:31")
  end

  test "should delete tour" do
    time = Time.zone.now
    tour = Tour.new(time: time, end_time: time + 1.hours, min_guides: 10, location: "HOG")
    assert tour.save
    post login_url,
      params: { email: "admin@vanderbilt.edu", password: "password" }
    get "/tours/#{tour.id}"
    assert_response :redirect
    assert_raises(ActiveRecord::RecordNotFound) do
      Tour.find(tour.id)
    end
  end

  

end
