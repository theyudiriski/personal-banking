class ApplicationController < ActionController::API
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def authenticate_user!
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user
  end

  private

  def default_page
    params[:page] || 1
  end

  def default_per_page
    per_page = params[:per_page].to_i
    max_per_page = 100
    default_per_page = 10

    if per_page.positive?
      [ per_page, max_per_page ].min
    else
      default_per_page
    end
  end
end
