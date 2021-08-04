require "digest"

class UserController < ApplicationController

  skip_before_action :verify_authenticity_token

  # GET /user
  # Get all users
  # TODO: Apply filtering
  def index

    if(params[:token].nil?)
      response.status = 400
      render json: {msg: "Token is not defined"}
      return
    end

    session = validate_session(params[:token])

    if session.nil?
      response.status = 401
      render json: {}
      return
    end

    obj = User.all

    if obj.empty?
      response.status = 404
      render json: {}
    else
      response.status = 200
      render json: obj
    end

  end

  # GET /user/:id
  # Get specific user by id
  def show

    if(params[:token].nil?)
      response.status = 400
      render json: {msg: "Token is not defined"}
      return
    end

    session = validate_session(params[:token])

    if session.nil?
      response.status = 401
      render json: {}
      return
    end

    begin
      obj = User.find(params[:id])
      response.status = 200
      render json: obj
    rescue ActiveRecord::RecordNotFound => e
      response.status = 404
      render json: {}
    rescue Exception => e
      response.status = 500
      render json: e
    end

  end

  # PUT /user/:id
  # Update user by id
  def update

    if(params[:token].nil?)
      response.status = 400
      render json: {msg: "Token is not defined"}
      return
    end

    session = validate_session(params[:token])

    if session.nil?
      response.status = 401
      render json: {}
      return
    end

    if params[:payload].nil?
      response.status = 400
      render json: {msg: "Payload is not defined in request"}
      return
    end

    begin
      obj = User.find(params[:id])

      unless session.user.id == obj.id
        response.status = 403
        render json: {}
        return
      end

      unless(params[:payload][:full_name].nil?)
        obj.full_name = params[:payload][:full_name]
      end

      unless(params[:payload][:email].nil?)
        obj.email = params[:payload][:email]
      end

      # Sending plain password
      # TODO: encrypt on client side
      unless(params[:payload][:password].nil?)
        obj.password = Digest::SHA256.hexdigest(params[:payload][:password])
      end

      if(obj.invalid?)
        response.status = 400
        r = {}
        obj.errors.map {|k, v| r[k] = v}
        render json: r
        return
      end

      obj.save

      response.status = 204
      render json: obj
    rescue ActiveRecord::RecordNotFound => e
      response.status = 404
      render json: {}
    rescue Exception => e
      response.status = 500
      render json: {msg: e}
    end

  end

  # POST /user
  # Create new user
  def create

    if params[:payload].nil?
      response.status = 400
      render json: {msg: "Payload is not defined in request"}
      return
    end

    full_name = params[:payload][:full_name]
    email = params[:payload][:email]
    password = params[:payload][:password]

    # Validation, password must satisfy following conditions:
    # 1. must contain at least one uppercase letter.
    # 2. must contain at least one lowercase letter.
    # 3. must contain at least one digit.
    # 4. must contain at least one special character: #?!@$ %^&*- (space is intentional)
    # Regex found on https://ihateregex.io/expr/password/
    # TODO: plain text password can't be saved on database. Use SHA.
    unless /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}\z/.match?(password)
      response.status = 400
      render json: {password: "Password must be 8 characters long. Must have one capital letter, one lowercase letter, one digit and one symbol (!@#$%^&*-)"}
      return
    end

    #Password hashing
    password = Digest::SHA256.hexdigest(password)

    obj = User.create(full_name: full_name, email: email, password: password)

    if(obj.invalid?)
      response.status = 400
      json_response = {}
      obj.errors.map {|k, v| json_response[k] = v}
      render json: json_response
      return
    end

    obj.save

    response.status = 201
    render json: obj

  end

  # DELETE /user/:id
  # Delete a user by id
  def destroy

    if(params[:token].nil?)
      response.status = 400
      render json: {msg: "Token is not defined"}
      return
    end

    session = validate_session(params[:token])

    if session.nil?
      response.status = 401
      render json: {}
      return
    end

    begin
      obj = User.find(params[:id])

      unless session.user.id == obj.id
        response.status = 403
        render json: {}
        return
      end

      # This is what slows down the response.
      # Big DB transactions that delete by foreign key.
      obj.time_sessions.destroy_all
      obj.login_sessions.destroy_all

      obj.destroy
      response.status = 20
      render json: {msg: obj.time_sessions.methods}
    rescue ActiveRecord::RecordNotFound => e
      response.status = 404
      render json: {}
    rescue Exception => e
      response.status = 500
      render json: {msg: e}
    end

  end

end
