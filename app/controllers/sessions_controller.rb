class SessionsController < ApplicationController
  def new
    redirect_to home_path if current_user
    @user = User.new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:success] = login_success
      redirect_to home_path
    else
      flash[:danger] = login_failed
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = logout_success
    redirect_to root_path
  end
end
