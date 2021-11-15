class ToursController < ApplicationController

    def new
        check_admin()
        @tour = Tour.new
    end

    def create
        check_admin()
        @tour = Tour.new(tour_params)
        @tour.end_time = @tour.time + params[:tour][:hours].to_i.hours
        @tour.save
        TourMailer.with(tour: @tour).tour_reminder.deliver_later(wait_until: @tour.time - 1.day)
        redirect_to tours_new_path
    end

    def manage
        check_admin()
    end

    def delete
        check_admin()
        Tour.find(params[:id]).delete
        redirect_back(fallback_location: root_path)
    end

    def manage_guides
        check_admin()
        @tour = Tour.find(params[:id])
    end

    def view_guides
        check_admin()
        @tour = Tour.find(params[:id])
    end

    def remove_guide
        check_admin()
        @tour = Tour.find(params[:tour])
        params[:user][:user_ids][1..].each do |user|
            @tour.users.delete(User.find(user))
        end
        redirect_to "/tours/manage/#{params[:tour]}"
    end

    def add_guide
        check_admin()
        @tour = Tour.find(params[:tour])
        params[:user][:user_ids][1..].each do |user|
            @tour.users.append User.find(user)
        end
        redirect_to "/tours/manage/#{params[:tour]}"
    end

    private

    def check_admin
        if !session[:user_id] || !User.find(session[:user_id]).administrator
            redirect_to root_path
        end
    end

    def tour_params
        params.require(:tour).except(:hours).permit(:time, :min_guides, :location, :note, :weekly, :weeks)
    end

end
