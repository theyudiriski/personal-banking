module Api
  class UsersController < ApplicationController
    def login
      user = User.find_by(email: params[:email].downcase)

      if user
        session[:user_id] = user.id
        render json: { message: "Login successful", user_id: user.id }, status: :ok
      else
        render json: { error: "Invalid email" }, status: :unauthorized
      end
    end

    def logout
      session[:user_id] = nil
      render json: { message: "Logout successful" }, status: :ok
    end

    def create
      user = User.new(user_params)

      if user.save
        render json: { user: user }, status: :created
      else
        render json: { errors: user.errors }, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email)
    end
  end
end
