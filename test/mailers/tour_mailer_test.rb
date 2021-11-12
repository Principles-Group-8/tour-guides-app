require "test_helper"

class TourMailerTest < ActionMailer::TestCase
  test "tour_reminder" do
    mail = TourMailer.with(tour: Tour.first).tour_reminder
    assert_equal "Upcoming Tour Reminder", mail.subject
    assert_equal [Tour.first.users.all.pluck(:email)], mail.to
    assert_equal ["VanderbiltTourGuides@gmail.com"], mail.from
    assert_match "Hello,

    This is a reminder that you have an upcoming tour tomorrow at <%=@tour_time%>.
    
    
    Please do not respond to this email. It was sent by an automated service.
    
        ", mail.body.encoded
  end

end
