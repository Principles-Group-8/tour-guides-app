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

    def delete_all
        check_admin()
        Tour.all.each do |tour|
            tour.delete
        end
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
        @tour = Tour.find(params[:tour_id])
        @user = User.find(params[:user_id])
        @tour.users.delete(@user)
        redirect_to "/tours/manage/#{params[:tour_id]}"
    end

    def add_guide
        check_admin()
        @tour = Tour.find(params[:tour_id])
        @user = User.find(params[:user_id])
        @tour.users.append @user
        redirect_to "/tours/manage/#{params[:tour_id]}"
    end

    def scheduler
    end

    def scheduler_post
        tours = Tour.find_by_weekly(true)
        scheduler = Hash.new

        tours.each do |tour|
            scheduler[tour] = Array.new
        end

        admins = User.select{|admin| admin.administrator && admin.has_availability}
        guides = User.select{|guide| !guide.administrator && guide.has_availability}

        scheduled = Array.new

        tours.each do |tour|
            found = false

            admins.each do |admin|
                if(admin.is_available(tour.availability))
                    scheduler[tour].push(admin)
                    scheduled.push(admin)
                    admins.remove(admin)
                    found = true
                    break
                end
            end

            if(!found)
            end
            
        end

        guides = guides.concat(admins)

        needed = guides.length() - 2

        tours.each do |tour|
            filled = false
            guides.each do |guide|
                if(guide.is_available(tour.availability))
                    scheduler[tour].push(guide)
                    scheduled.push(guide)
                    guides.remove(guide)
                    if(scheduler[tour].length >= needed)
                        filled = true
                        break
                    end
                end
            end

            if(!filled)
            end
        end

        guides.each do |guide|
            tours.each do |tour|
                if(guide.is_available(tour.availability))
                    scheduler[tour].push(guide)
                    scheduled.push(guide)
                    guides.remove(guide)
                    break
                end
            end
        end

        tours.each do |tour|
            for week in 0..(tour.weeks - 1)
                tempTour = tour.dup()
                tempTour.weekly = false
                tempTour.weeks = 1
                tempTour.time += week.weeks
                tempTour.end_time += week.weeks
                tempTour.min_guides = scheduler[tour].length
                tempTour.save
                scheduler[tour].each do |guide|
                    tempTour.users.append guide
                end
            end
            tour.delete
        end

        #go through each tour and add an available administrator to each
        #if no available administrator
            #go back through already scheduled administrators and find available one
            #take that administrator and re-schedule for tour that administrator was taken from
            #if no available administrators, just move on (fail case)
        #once there's an admin per tour, then add remaining admins to regular tour guide pool

        #calculate needed number of guides per tour (total guides (with availability) / total tours) and subtract 2 (stored as variable needed)

        #go through each tour and add guides until needed is hit
        #if no available guides with that tour availability and needed is not hit
            #go back through already scheduled guides and find available one
            #take that guide and re-schedule to fill that spot for the tour that guide was taken from
        #if there's not enough guides in the whole system to fill a tour
            #change needed to the max amount of guides that can fit there and keep going with scheduling
        #once needed is met per tour, attempt to assign all remaining guides to any spot they're available for

        #list guides in UI that couldn't be scheduled
        #create tours and assign guides

        flash[:danger] = "The following guides were not scheduled: #{guides.to_s}"
        redirect_to tours_scheduler_path

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
