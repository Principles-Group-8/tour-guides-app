class ApplicationController < ActionController::Base
end
def current_time
    Time.now.utc + Time.now.in_time_zone('America/Chicago').utc_offset
end