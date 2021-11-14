class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def points
    if !session[:user_id]
      redirect_to root_path
    end
    @data = User.all
  end

  def availability
    if !session[:user_id] || !User.find(session[:user_id])
      redirect_to root_path
    end
  end

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

  def check_in_post
    if !session[:user_id]
      redirect_to root_path
    end
    @user = User.find(session[:user_id])
    @user.points = @user.points + 1
    @user.save
    flash[:success] = "Points Updated"
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

  def list
    check_admin()
  end

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

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Success"
      redirect_to users_availability_path
    else
      flash.now[:danger] = "Please enter a valid email"
      render :new
    end
  end

  def subboard_remove
    if !session[:user_id]
      redirect_to root_path
    end
    user = User.find(session[:user_id])
    params[:user][:tour_ids][1..].each do |tour|
      user.tours.delete(Tour.find(tour))
    end
    redirect_to users_subboard_path
  end 

  def subboard_claim
    if !session[:user_id]
      redirect_to root_path
    end
    user = User.find(session[:user_id])
    params[:user][:tour_ids][1..].each do |tour|
      user.tours.append Tour.find(tour)
    end
    redirect_to users_subboard_path
  end

  def delete
    check_admin()
    User.find(params[:id]).delete
    redirect_back(fallback_location: root_path)
  end

  private
  def check_admin
    if !session[:user_id] || !User.find(session[:user_id]).administrator
        redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

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
