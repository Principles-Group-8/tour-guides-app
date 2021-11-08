# Preview all emails at http://localhost:3000/rails/mailers/tour_mailer
class TourMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/tour_mailer/tour_reminder
  def tour_reminder
    TourMailer.with(tour: Tour.first).tour_reminder
  end

end
