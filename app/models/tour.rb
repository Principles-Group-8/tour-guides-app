class Tour < ApplicationRecord
    has_and_belongs_to_many :users

    def display
        "#{time.strftime('%A')} #{time.month}/#{time.day} #{time.strftime('%-I:%M')} - #{end_time.strftime('%-I:%M %p')}"
    end

    def time_display
        "#{time.strftime('%-I:%M')} - #{end_time.strftime('%-I:%M %p')}"
    end
end
