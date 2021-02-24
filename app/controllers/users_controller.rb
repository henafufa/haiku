class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :show, :followers, :following ]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    # @users = User.all
    # @users = User.paginate(page: params[:page])
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  def show
    @comment = Comment.new
    @reaction = Reaction.new
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
    @microposts = @user.microposts.paginate(:page => params[:page], :per_page => 5, :total_entries => 30)
    # debugger
  end
  def new
    @user = User.new
  end
  def create
    # @user = User.new(params[:user]) # Not the final
    # implementation!
    @user = User.new(user_params)

    if @user.save
    # Handle a successful save.
      # log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user
      # UserMailer.account_activation(@user).deliver_now
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  def edit
    @user = User.find(params[:id])
  end
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      #handle a successful update
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page], :per_page => 10, :total_entries => 50)
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page], :per_page => 10, :total_entries => 50)
    render 'show_follow'
  end
  def search
    # Friend.where(["email LIKE ?", "% {params[:q]} %"])
    @users = User.where("email LIKE ?", "%" + params[:search] + "%").paginate(page: params[:page])
    render 'index'
    # @friends = Friend.search(params[:search])
  end
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    # def logged_in_user
    #   unless logged_in?
    #     store_location
    #     flash[:danger] = "Please log in."
    #     redirect_to login_url
    #   end
    # end
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
