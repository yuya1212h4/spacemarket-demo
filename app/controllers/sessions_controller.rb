class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash.now[:success] = "ログインしました"
      redirect_to user # user_url(user)
    else
      flash.now[:danger] = "ログインできませんでした"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    render 'new'
  end
end
