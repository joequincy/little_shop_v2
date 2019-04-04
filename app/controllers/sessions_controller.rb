class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user&.authenticate(params[:password])
      session[:user_id] = user.id.to_s
      redirect_to profile_path
    else
      flash.now.error = "Incorrect email address or password."
      render :new
    end
  end
end
