require "test_helper"

class ToursControllerTest < ActionDispatch::IntegrationTest
  test "should get new tour" do
    get tours_new_url
    assert_response :found
  end

  test "should get tour manager" do
    get tours_manage_url
    assert_response :ok
  end

  test "should create new tour" do
    post tours_create_url,
      params:  { tour: { time: "2022-02-11T16:31", hours: 1, min_guides: 5, location: "HOG", note: "testing", weekly: 0 } }
    assert Tour.find_by_time("2022-02-11T16:31")
  end
end
