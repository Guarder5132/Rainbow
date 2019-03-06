class UsersController < ApplicationController
  before_action :signed_in_user, only:[:update,:edit]
  before_action :correct_user,   only:[:update,:edit]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      redirect_to @user
      flash[:success] = "注册成功"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      sign_in @user
      redirect_to @user
      flash[:success] = "更改成功"
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  private

    def user_params 
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def signed_in_user 
      unless signed_in?
        redirect_to signin_path, notice: "请登录!"
      end
    end

    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        redirect_to root_path ,notice: "无法向其他用户有想法!"
      end
    end
end
