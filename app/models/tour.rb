class Tour < ApplicationRecord
    has_and_belongs_to_many :users

    #Function to display a date in the proper format
    def date_display
        "#{time.strftime('%A')} #{time.month}/#{time.day}"
    end

    #Function to display a day in the proper format
    def day_display
        "#{time.strftime('%A')}"
    end

    #Function to fully display a tour
    def display
        "#{time.strftime('%A')} #{time.month}/#{time.day} #{time.strftime('%-I:%M')} - #{end_time.strftime('%-I:%M %p')}"
    end

    #Function to display a time in the proper format
    def time_display
        "#{time.strftime('%-I:%M %p')} - #{end_time.strftime('%-I:%M %p')}"
    end

    #Function to display a tour details in the proper format
    def details_display
        s = "Location: #{location}"
        if !note.empty?
            s += "\nNotes: #{note}"
        end
        s
    end

    #Function to determine if a time is in the current day
    def today?
        time < current_time + 1.day
    end

    def start_time
        current_time
    end

    #Function to properly format availability
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

        start_num = time.strftime('%H').to_i
        start_thirty = time.strftime('%M').to_i >= 30

        end_num = end_time.strftime('%H').to_i
        add_thirty = end_time.strftime('%M').to_i > 30
        # if end_num < 9
        #     end_num += 12
        # end
        # if start_num < 9
        #     end_num += 12
        # end

        if start_thirty
            hour_num = start_num
            if start_num > 12
                hour_num -= 12
            end
            array << base + hour_num.to_s + ":30"
            start_num += 1
        end
        
        for hour in start_num..end_num do
            if hour > 12
                adj_hour = hour - 12
            else
                adj_hour = hour
            end
            array << base + adj_hour.to_s
            if hour != end_num || add_thirty
                array << base + adj_hour.to_s + ":30"
            end
        end

        array
    end

end
