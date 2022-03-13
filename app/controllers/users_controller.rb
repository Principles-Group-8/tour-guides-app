class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  #Function to store data with all users
  def points
    if !session[:user_id]
      redirect_to root_path
    end
    @data = User.all
  end

  #Function to direct to correct rootpath based upon whether availability has been entered
  def availability
    if !session[:user_id] || !User.find(session[:user_id])
      redirect_to root_path
    end
  end

  #Function to fill the availability part of database for a user
  def availability_post
    if !session[:user_id]
      redirect_to root_path
    end
    new_params = {}
    params.each do |k, v|
      if v == "on"
        new_params[k] = true
      end
    end
    @user = User.find(session[:user_id])
    @user.clear_availability
    @user.update(new_params)
    flash[:success] = "Availability Updated"
    redirect_to root_path
  end

  def check_in
    if !session[:user_id]
      redirect_to root_path
    end
  end

  #Function to check in and update user's points if in the correct time
  def check_in_post
    if !session[:user_id]
      redirect_to root_path
    end
    @user = User.find(session[:user_id])
    @tour = Tour.find(params[:tour_id])
    if @tour.time - 15*60 < current_time && @tour.time + 15*60 > current_time
      if(params[:tour_given])
        @user.points = @user.points + 1
        @user.save
      end
      @tour.checked_in_email << @user.email
      @tour.save
      flash[:success] = "Checked In"
    else
      flash[:danger] = "Not the right time"
    end
    redirect_back(fallback_location: root_path)
  end

  #Function to update user points if told to do so by an administrator
  def manual_check_in
    check_admin()
    @user = User.find(params[:user_id])
    @tour = Tour.find(params[:tour_id])
    if(params[:tour_given] == "true")
      @user.points = @user.points + 1
      @user.save
    end
    @tour.checked_in_email << @user.email
    @tour.save
    redirect_back(fallback_location: root_path)
  end

  def profile
    if !session[:user_id]
      redirect_to root_path
    end
  end

  def subboard
    if !session[:user_id]
      redirect_to root_path
    end
  end

  def change_points
    check_admin()
    @user = User.find(params[:id])
    @user.update_attribute(:points, params[:points])
    redirect_to root_path
end

  #Function to store user variable with a new user
  def new
    @user = User.new
  end

  def login
    if session[:user_id] && User.find(session[:user_id])
      redirect_to users_profile_path
    end
  end

  def logout
    session.delete(:user_id)
    redirect_to login_path
  end

  #Funciton to list all guides
  def list
    check_admin()
    User.all.each do |user|
      absences = 0
      user.tours.all.select {|tour| tour.end_time < current_time}.each do |tour|
        if (!tour.checked_in_email.include? user.email)
          absences = absences + 1
        end
        user.absences = absences
        user.save
      end
    end
  end

  #Function to reset all points
  def reset_points
    check_admin()
    User.all.each do |user|
      user.points = 0
      user.save
    end
    redirect_back(fallback_location: root_path)
  end

  #Function to login
  def login_submit
    @user = User.find_by_email(params[:email])
    if !!@user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash[:danger] = "Error: Incorrect username or password"
      redirect_to login_path
    end
  end

  #Function to create a new user
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Success"
      redirect_to users_availability_path
    elsif @user.first_name == ""
      flash.now[:danger] = "Please enter a first name"
      render :new
    elsif @user.last_name == ""
      flash.now[:danger] = "Please enter a last name"
      render :new
    else
      flash.now[:danger] = "Please enter a valid email"
      render :new
    end
  end

  #Function to remove a tour from the subboard
  def subboard_remove
    if !session[:user_id]
      redirect_to root_path
    end
    user = User.find(session[:user_id])
    @tour = Tour.find(params[:tour_id])
    user.tours.delete(@tour)
    redirect_to users_subboard_path
  end 

  #Function to claim a tour from the subboard
  def subboard_claim
    if !session[:user_id]
      redirect_to root_path
    end
    user = User.find(session[:user_id])
    @tour = Tour.find(params[:tour_id])
    user.tours.append @tour
    redirect_to users_subboard_path
  end

  #Function to delete a user
  def delete
    check_admin()
    @user = User.find(params[:id])
    if @user.id == session[:user_id]
      flash[:danger] = "You cannot delete yourself"
      redirect_back(fallback_location: root_path)
      return
    end
    @user.delete
    redirect_back(fallback_location: root_path)
  end

  #Function to make a user an admin
  def make_admin
    check_admin()
    @user = User.find(params[:id])
    @user.administrator = true
    @user.save
    redirect_back(fallback_location: root_path)
  end

  #Function to remove administrative priviledges from an admin
  def revoke_admin
    check_admin()
    @user = User.find(params[:id])
    if @user.id == session[:user_id]
      flash[:danger] = "You cannot revoke your own admin status"
      redirect_back(fallback_location: root_path)
      return
    end
    @user.administrator = false
    @user.save
    redirect_back(fallback_location: root_path)
  end

  private
  #Function to check if a user is an admin
  def check_admin
    if !session[:user_id] || !User.find(session[:user_id]).administrator
        redirect_to root_path
    end
  end

  #Function to fill a user with specified parameters
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  #Function to use the availability
  def availability_params
    params.permit(
      ["mon", "tues", "wed", "thur", "fri", "sat", "sun"].each do |day|
        ["_9", "_9:30", "_10", "_10:30", "_11", 
          "_11:30", "_12", "_12:30", "_1", "_1:30",
          "_2", "_2:30", "_3", "_3:30", "_4", "_4:30",
          "_5", "_5:30"].each do |time|
            "#{day}#{time}"
          end
        end
    )
    
  end

end
