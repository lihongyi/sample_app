class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  #before_filter :signed_in_user
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  
  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    if signed_in?
      flash[:info] = "You're already signed in!"
      redirect_to root_path
    else
      @user = User.new
    end
  end

  def create
    if signed_in?
      flash[:info] = "You already exist!"
      redirect_to root_path
    else

    	@user = User.new(params[:user])
    	if @user.save
        sign_in @user
    		flash[:success] = "Welcome to the Sample App!"
    		redirect_to @user
    	else
    		render 'new'
    	end

    end
  end

  def edit
    #@user = User.find(params[:id]) # no need anymore because before_filter did the same
  end

  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page]) #User.paginate(page: params[:page], per_page: 10) if want display 10 per page
  end

  def destroy
    tempUser = User.find(params[:id])
    if tempUser.admin?
      flash[:info] = "You are an Admin! Why would you want to delete yourself? Being an admin is a priviledge many would die to have"
      redirect_to users_path
    else
      tempUser.destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    end
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
