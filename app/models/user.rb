class User < ApplicationRecord
    has_secure_password
    validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@vanderbilt.edu\z/, message: 'Invalid email' }
    validates :first_name, presence: true
    validates :last_name, presence: true
    has_and_belongs_to_many :tours

    #Function to clear availability
    def clear_availability
        false_hash = {}
        ["mon", "tues", "wed", "thur", "fri", "sat", "sun"].each do |day|
            ["_9", "_9:30", "_10", "_10:30", "_11", 
              "_11:30", "_12", "_12:30", "_1", "_1:30",
              "_2", "_2:30", "_3", "_3:30", "_4", "_4:30",
              "_5", "_5:30"].each do |time|
              false_hash["#{day}#{time}".to_sym] = false
            end
          end
          update(false_hash)
    end

    #Function to determine if a user has any availability entered
    def has_availability
      ["mon", "tues", "wed", "thur", "fri", "sat", "sun"].each do |day|
        ["_9", "_9:30", "_10", "_10:30", "_11", 
          "_11:30", "_12", "_12:30", "_1", "_1:30",
          "_2", "_2:30", "_3", "_3:30", "_4", "_4:30",
          "_5", "_5:30"].each do |time|
          if send("#{day}#{time}")
            return true
          end
        end
      end
      false
    end

    #Function to properly display a user's name
    def name_display
      "#{first_name} #{last_name}"
    end

    #Function to determine if a user is available for a certain time
    def is_available(times)
      times.each do |time|
        if !send(time)
          return false
        end
      end
      true
    end

end
