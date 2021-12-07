module ApplicationHelper
    #Function to determine if a user is logged in
    def logged_in?
        !!session[:user_id] && !!User.find(session[:user_id])
    end

    #Function to get the current user
    def current_user
        @user ||= User.find(session[:user_id]) if !!session[:user_id]
    end

    #Function to determine if a user is an administrator
    def administrator?
        current_user && current_user.administrator
    end

    #Function to determine if a user is checked in for a current tour
    def checked_in?(tour_id)
        @tour = Tour.find(tour_id)
        @tour.checked_in_email.include? current_user.email
    end

end
