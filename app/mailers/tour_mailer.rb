class TourMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.tour_mailer.tour_reminder.subject
  #

  #Function to send an email
  def tour_reminder(tour)
    @tour = tour
    @tour_time = @tour.time_display

    mail(
      to: @tour.users.all.pluck(:email),
      subject: "Upcoming Tour Reminder"
    )
  end
end
