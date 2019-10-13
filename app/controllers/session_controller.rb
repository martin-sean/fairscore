class SessionController < ApplicationController

  # GET /login
  def new
  end

  # POST /login
  def create
    return if logged_in?

    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to root_path
    else
      flash.now[:error] = 'Username or password was invalid'
      render 'new'
    end
  end

  # GET /logout
  def destroy
    log_out if logged_in?
    flash[:success] = 'You have been logged out'
    redirect_to root_path
  end

end
