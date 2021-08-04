require "digest"

class LoginSessionController < ApplicationController

  skip_before_action :verify_authenticity_token

  # POST /login
  def login

    if(params[:payload][:email].nil? || params[:payload][:password].nil?)
      response.status = 400
      render json: {msg: "Bad request: e-mail or password is not present in request body."}
      return
    end

    obj = User.find_by(
      email: params[:payload][:email],
      password: Digest::SHA256.hexdigest(params[:payload][:password])
    )

    if obj.nil?
      response.status = 403
      render json: {msg: "Access denied."}
      return
    end

    unless obj.is_active
      response.status = 403
      render json: {msg: "Access denied."}
      return
    end

    response.status = 200
    render json: obj.login

  end

  # POST /logout
  def logout

    if(params[:token].nil?)
      response.status = 400
      render json: {}
      return
    end

    obj = validate_session(params[:token])

    if obj.nil?
      response.status = 401
      render json: {}
      return
    end

    response.status = 200
    obj.end = Time.new
    obj.save
    render json: obj

  end

  # It is a good way to get user information, but if someone finds out our new_session
  # token, they can also get our data.
  # TODO: Implement CSRF token, that gets refreshed with every HTTP request.
  def current

    if(params[:token].nil?)
      response.status = 400
      render json: {}
      return
    end

    obj = validate_session(params[:token])

    if obj.nil?
      response.status = 401
      render json: {}
      return
    end

    response.status = 200
    render json: obj

  end

end
