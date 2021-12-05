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
        tours = Tour.select{|tour| tour.weekly}
        scheduler = Hash.new

        tours.each do |tour|
            scheduler[tour] = Array.new
        end

        admins = User.select{|admin| admin.administrator && admin.has_availability}
        guides = User.select{|guide| !guide.administrator && guide.has_availability}

        adminAvailability = Hash.new
        admins.each do |admin|
            available = 0
            tours.each do |tour|
                if(admin.is_available(tour.availability))
                    available += 1
                end
            end
            adminAvailability[admin] = available
        end

        adminAvailability.sort_by{|k, v| v}.each do |admin, _|
            tours.each do |tour|
                if(admin.is_available(tour.availability) && scheduler[tour].length == 0)
                    scheduler[tour].push(admin)
                    admins.delete(admin)
                    break
                end
            end
        end

        guides = guides.concat(admins)

        tourAvailability = Hash.new
        tours.each do |tour|
            available = 0
            guides.each do |guide|
                if(guide.is_available(tour.availability))
                    available += 1
                end
            end
            tourAvailability[tour] = available
        end

        guideAvailability = Hash.new
        guides.each do |guide|
            available = 0
            tours.each do |tour|
                if(guide.is_available(tour.availability))
                    available += 1
                end
            end
            guideAvailability[guide] = available
        end

        filled = Hash.new
        tours.each do |tour|
            filled[tour] = false
        end

        while(any_false(filled))
            tourAvailability.sort_by{|k, v| v}.each do |tour, _|
                if(filled[tour])
                    next
                end
                found = false
                guideAvailability.sort_by{|k, v| v}.each do |guide, _|
                    if(guide.is_available(tour.availability))
                        scheduler[tour].push(guide)
                        guides.delete(guide)
                        guideAvailability.delete(guide)
                        found = true
                        break
                    end
                end
                if(!found)
                    filled[tour] = true
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

        temp = "The following guides were not scheduled:"
        guides.each do |guide|
            temp +=  " " + guide.name_display + ","
        end
        flash[:danger] = temp
        redirect_to tours_scheduler_path

    end

    private

    def any_false(hash)
        hash.each do |_, v|
            if v == false
                return true
            end
        end
        false
    end

    def check_admin
        if !session[:user_id] || !User.find(session[:user_id]).administrator
            redirect_to root_path
        end
    end

    def tour_params
        params.require(:tour).except(:hours).permit(:time, :min_guides, :location, :note, :weekly, :weeks)
    end

end
