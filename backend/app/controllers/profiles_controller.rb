class ProfilesController < ApplicationController
  def show
    render json: {
      id: @current_user.id,
      name: @current_user.name,
      email: @current_user.email
    }
  end
end