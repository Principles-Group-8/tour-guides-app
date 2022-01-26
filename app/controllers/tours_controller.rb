class ToursController < ApplicationController

    #Function to store tour variable with an empty tour
    def new
        check_admin()
        @tour = Tour.new
    end

    #Function for creating new tours given the set tour parameters
    def create
        check_admin()
        @tour = Tour.new(tour_params)
        @tour.end_time = @tour.time + params[:tour][:hours].to_i.hours
        @tour.save
        flash[:success] = "Tour Created"
        redirect_to tours_new_path
    end

    def manage
        check_admin()
    end

    #Function for deleting a tour by tour id
    def delete
        check_admin()
        Tour.find(params[:id]).delete
        redirect_back(fallback_location: root_path)
    end

    #Function for deleting all tours
    def delete_all
        check_admin()
        Tour.all.each do |tour|
            tour.delete
        end
        redirect_back(fallback_location: root_path)
    end

    #Function to store tour variable with tour found by an id
    def manage_guides
        check_admin()
        @tour = Tour.find(params[:id])
    end

    #Function to store tour variable with tour found by an id
    def view_guides
        check_admin()
        @tour = Tour.find(params[:id])
    end

    #Function for removing all guides on a tour
    def remove_guide
        check_admin()
        @tour = Tour.find(params[:tour_id])
        @user = User.find(params[:user_id])
        @tour.users.delete(@user)
        redirect_to "/tours/manage/#{params[:tour_id]}"
    end

    #Function for adding a guide to a tour
    def add_guide
        check_admin()
        @tour = Tour.find(params[:tour_id])
        @user = User.find(params[:user_id])
        @tour.users.append @user
        redirect_to "/tours/manage/#{params[:tour_id]}"
    end

    def scheduler
    end

    #Function to perform the scheduling algorithm
    def scheduler_post
        logger.debug("ENTERING SCHEDULING ALGO")
        logger.debug()

        tours = Tour.select{|tour| tour.weekly} #creating an array of all tours with weekly tag
        scheduler = Hash.new

        #building a hash where each key is a tour and each value is an empty array
        tours.each do |tour|
            scheduler[tour] = Array.new
        end

        #creating arrays for the admins and non-admins
        admins = User.select{|admin| admin.administrator && admin.has_availability}
        guides = User.select{|guide| !guide.administrator && guide.has_availability}

        logger.debug("ADMINS = ")
        admins.each do |admin|
            logger.debug(admin.email)
        end

        logger.debug("GUIDES = ")
        guides.each do |guide|
            logger.debug(guide.email)
        end
        logger.debug()

        #creating a hash where the key is an admin user and the value is the number of tours they're available for
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

        #adding the least available admins to a tour first until all tours have 1 admin or we've gone through all the admins
        adminAvailability.sort_by{|k, v| v}.each do |admin, _|
            tours.each do |tour|
                if(admin.is_available(tour.availability) && scheduler[tour].length == 0)
                    logger.debug("admin added is: ")
                    logger.debug(admin.email)

                    logger.debug("tour added to is: ")
                    logger.debug(tour.display)

                    scheduler[tour].push(admin)
                    admins.delete(admin)
                    break
                end
            end
        end

        logger.debug("ADMINS ARE (should be none): ")
        admins.each do |admin|
            logger.debug(admin.email)
        end

        #adding extra admins into normal guide pool
        guides = guides.concat(admins)

        logger.debug("GUIDES ARE: ")
        guides.each do |guide|
            logger.debug(guide.email)
        end
        logger.debug()

        #creating a hash where the key is a tour and the value is the number of guides available for that tour
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

        #creating a hash where the key is a guide and the value is the number of tours that guide is available for
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

        #creating a hash where the key is a tour and the values is false (representing if the tour has been filled)
        filled = Hash.new
        tours.each do |tour|
            filled[tour] = false
        end

        #while there's still a tour that has guides available for it
        while(any_false(filled))
            #looking at the least available tour and attempting to fill it with the least available guide, adding 1 guide to a tour at a time
            tourAvailability.sort_by{|k, v| v}.each do |tour, _|
                if(filled[tour])
                    next
                end
                found = false
                guideAvailability.sort_by{|k, v| v}.each do |guide, _|
                    if(guide.is_available(tour.availability))
                        scheduler[tour].push(guide)

                        logger.debug("guide added is: ")
                        logger.debug(guide.email)

                        logger.debug("tour added to is: ")
                        logger.debug(tour.display)

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

        logger.debug()
        logger.debug("ENTERING TOUR CREATION")
        logger.debug()

        #creating all of the tours in the system
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
                    logger.debug("Adding guide: ")
                    logger.debug(guide.email)

                    logger.debug("Adding to tour: ")
                    logger.debug(tour.display)
                end
            end
            tour.delete
        end

        #displaying guides that were unable to be scheduled
        temp = "The following guides were not scheduled:"
        guides.each do |guide|
            temp +=  " " + guide.name_display + ","
        end
        flash[:danger] = temp
        redirect_to tours_scheduler_path

    end

    private

    #Function that is determining if there are any false values in a hash
    def any_false(hash)
        hash.each do |_, v|
            if v == false
                return true
            end
        end
        false
    end

    #Function to determine if a User is an admin
    def check_admin
        if !session[:user_id] || !User.find(session[:user_id]).administrator
            redirect_to root_path
        end
    end

    #Function to get the parameters of a tour
    def tour_params
        params.require(:tour).except(:hours).permit(:time, :min_guides, :location, :note, :weekly, :weeks)
    end

end
