class Tour < ApplicationRecord
    has_and_belongs_to_many :users

    def date_display
        "#{time.strftime('%A')} #{time.month}/#{time.day}"
    end

    def day_display
        "#{time.strftime('%A')}"
    end

    def display
        "#{time.strftime('%A')} #{time.month}/#{time.day} #{time.strftime('%-I:%M')} - #{end_time.strftime('%-I:%M %p')}"
    end

    def time_display
        "#{time.strftime('%-I:%M')} - #{end_time.strftime('%-I:%M %p')}"
    end

    def today?
        time < current_time + 1.day
    end

    def availability
        case time.strftime('%A')
        when "Monday"
            base = "mon_"
        when "Tuesday"
            base = "tues_"
        when "Wednesday"
            base = "wed_"
        when "Thursday"
            base = "thur_"
        when "Friday"
            base = "fri_"
        when "Saturday"
            base = "sat_"
        when "Sunday"
            base = "sun_"
        end
        array = []
        start_num = time.strftime('%I').to_i
        end_num = end_time.strftime('%I').to_i
        add_thirty = end_time.strftime('%M').to_i >= 30
        
        for hour in start_num..end_num do
            array << base + hour.to_s
            if hour != end_num || add_thirty
                array << base + hour.to_s + ":30"
            end
        end

        array
    end

end
