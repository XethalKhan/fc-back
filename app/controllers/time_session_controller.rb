require 'time'

class TimeSessionController < ApplicationController

  # Error that was solved with StackOverflow.
  # TODO: Find a link that was used to solve the issue.
  skip_before_action :verify_authenticity_token

  # GET /session
  # Get all sessions
  def index

    if(params[:token].nil?)
      response.status = 400
      render json: {}
      return
    end

    session = validate_session(params[:token])

    if session.nil?
      response.status = 401
      render json: {}
      return
    end

    filter = {}

    if !params[:date].nil? && /\A\d{4}-[01]\d-[0-3]\d\z/.match?(params[:date])
      t = Time.parse(params[:date])
      filter[:start] = t.midnight..(t.midnight + 1.day)
    end

    obj = TimeSession.where(filter)

    if obj.empty?
      response.status = 404
      render json: obj
    else
      response.status = 200
      render json: obj
    end

  end

  # GET /session/:id
  # Get specific session by id
  def show

    if(params[:token].nil?)
      response.status = 400
      render json: {}
      return
    end

    session = validate_session(params[:token])

    if session.nil?
      response.status = 401
      render json: {}
      return
    end

    begin
      obj = TimeSession.find(params[:id])
      response.status = 200
      render json: obj
    rescue ActiveRecord::RecordNotFound => e
      response.status = 404
      render json: {}
    rescue Exception => e
      response.status = 500
      render json: {}
    end

  end

  # POST /session/start
  # Start a session
  # For session start to be recorded in database, we demand that client defines start time.
  # Doing so, client can startthe stopwatch smoothly without interuptions.
  # If request fails, client can try again with the same request,
  # while stopwatch keeps counting without interruptions.
  # TODO: check token.
  def start

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

    if params[:payload][:date].nil?
      response.status = 400
      render json: {msg: "Date field is not defined in request"}
      return
    end

    str = params[:payload][:date]

    # https://stackoverflow.com/questions/3143070/javascript-regex-iso-datetime#3143231
    unless /\d{4}-[01]\d-[0-3]\dT[0-2]\d:[0-5]\d:[0-5]\d\.\d+([+-][0-2]\d:[0-5]\d|Z)/.match?(str)
      response.status = 400
      render json: {msg: "date field is in bad format"}
      return
    end

    unless session.user.time_sessions.where(end: nil).empty?
      response.status = 403
      render json: {}
      return
    end

    startTime = Time.parse(str)

    obj = TimeSession.new
    obj.start = startTime
    obj.user = session.user
    obj.save

    response.status = 201
    render json: obj
  end

  # POST /session/end
  # Finish currently running session
  def end

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

    obj = session.user.time_sessions.where(end: nil)

    if obj.empty?
      response.status = 404
      render json: {}
      return
    end

    obj[0].end = Time.now
    obj[0].save

    response.status = 204

  end

  # GET /session/active
  # Get currently running session
  def active

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

    obj = session.user.time_sessions.where(end: nil)

    if obj.empty?
      response.status = 404
      render json: {}
    else
      response.status = 200
      render json: obj[0]
    end

  end

  # DELETE /session/:id
  # Delete a session by id
  def destroy

    if(params[:token].nil?)
      response.status = 400
      render json: {}
      return
    end

    session = validate_session(params[:token])

    if session.nil?
      response.status = 401
      render json: {}
      return
    end

    begin
      obj = TimeSession.find(params[:id])

      unless session.user.id == obj.user.id
        response.status = 403
        render json: {}
        return
      end

      obj.destroy
      response.status = 204
    rescue ActiveRecord::RecordNotFound => e
      response.status = 404
      render json: {}
    rescue Exception => e
      response.status = 500
      render json: {msg: e}
    end

  end

end
