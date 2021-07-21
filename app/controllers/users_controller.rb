class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update]

  def show
    
    @articles = @user.articles.paginate(page: params[:page], per_page: 2)
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 2)
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "Your account information was successfully updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to articles_path, notice: t('.notice', user: @user.username)
    else
      render 'new'
    end
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
  
  private
  def set_user
    @user = User.find(params[:id])
  end

end