class SessionsController < ApplicationController
  skip_before_action :authorize_request, only: [:create]
  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base, 'HS256')
      render json: {
        message: '로그인 성공',
        token: token,
        user: {
          id: user.id,
          name: user.name,
          email: user.email
        }
      }, status: :ok
    else
      render json: { error: '이메일 또는 비밀번호가 올바르지 않습니다' }, status: :unauthorized
    end
  end
end