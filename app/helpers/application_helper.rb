module ApplicationHelper
    def logged_in?
        !!session[:user_id] && !!User.find(session[:user_id])
    end

    def current_user
        @user ||= User.find(session[:user_id]) if !!session[:user_id]
    end

    def administrator?
        current_user && current_user.administrator
    end

    def checked_in?(tour_id)
        @tour = Tour.find(tour_id)
        @tour.checked_in_email.include? current_user.email
    end

end
