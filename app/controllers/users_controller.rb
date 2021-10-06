class UsersController < ApplicationController
  def availability
  end

  def profile
  end

  def new
    @user = User.new
  end

  def login
  end

  def logout
    session.delete(:user_id)
  end

  def list
    if !session[:user_id] || !User.find(session[:user_id]).administrator
      redirect_to root_path
    end
  end

  def login_submit
    @user = User.find_by_email(params[:email])
    if !!@user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash[:error] = "Error: Incorrect username or password"
      redirect_to login_path
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Success"
      redirect_to root_path
    else
      flash.now[:error] = "Please enter a valid email"
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
