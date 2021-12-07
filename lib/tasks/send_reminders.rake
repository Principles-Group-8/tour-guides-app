namespace :send_reminders do
    task :send => :environment do
        Tour.select{|tour| tour.today? }.each do |tour|
            TourMailer.tour_reminder(tour.id).deliver_now
        end
    end
end
