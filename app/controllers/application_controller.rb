class ApplicationController < ActionController::Base
end
def current_time
    TZInfo::Timezone.get("US/Central").now
end