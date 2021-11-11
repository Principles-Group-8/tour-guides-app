class ToursController < ApplicationController

    def new
        if !session[:user_id] || !User.find(session[:user_id]).administrator
            redirect_to root_path
        end
        @tour = Tour.new
    end

    def create
        if !session[:user_id] || !User.find(session[:user_id]).administrator
            redirect_to root_path
        end
        @tour = Tour.new(tour_params)
        @tour.end_time = @tour.time + params[:tour][:hours].to_i.hours
        @tour.save
        TourMailer.with(tour: @tour).tour_reminder.deliver_later(wait_until: @tour.time - 1.day)
        redirect_to tours_new_path
    end

    private

    def tour_params
        params.require(:tour).except(:hours).permit(:time, :min_guides, :location, :note, :weekly, :weeks)
    end

end
