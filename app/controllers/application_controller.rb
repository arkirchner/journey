class ApplicationController < ActionController::Base
  before_action :redirect_when_unauthorized
  helper_method :current_user

  private

  def current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def redirect_when_unauthorized
    redirect_to root_url unless current_user
  end
end
