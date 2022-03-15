class ApplicationController < ActionController::Base
end
def current_time
    Time.now.utc - 5.hours
end