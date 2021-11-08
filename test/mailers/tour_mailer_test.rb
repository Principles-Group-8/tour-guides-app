require "test_helper"

class TourMailerTest < ActionMailer::TestCase
  test "tour_reminder" do
    mail = TourMailer.tour_reminder
    assert_equal "Tour reminder", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
