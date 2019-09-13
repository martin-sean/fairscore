class SessionController < ApplicationController

  def new
  end

  def create
    user = User.find_by(username: params[:session][:username])
    if user &.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(coord) : forget(coord)
      redirect_to root_path
    else
      flash.now[:error] = 'Email or password was invalid'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = 'You have been logged out'
    redirect_to root_path
  end

end
