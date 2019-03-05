class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to user
      flash[:success] = "登录成功"
    else
      flash.now['error'] = "密码错误或者邮箱不存在"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
