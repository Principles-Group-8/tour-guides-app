class ApplicationController < ActionController::Base
end
def current_time
    Time.now.utc - 6.hours
end