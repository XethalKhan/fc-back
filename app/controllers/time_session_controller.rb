class TimeSessionController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index

    filter = {}

    unless params[:date].nil?
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

  def show

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

  def start
    obj = TimeSession.new
    obj.start = Time.now
    obj.save

    response.status = 201
    render json: obj
  end

  def end

    obj = TimeSession.find_by(end: nil)

    if obj.nil?
      response.status = 404
      render json: {}
    else
      obj.end = Time.now
      obj.save

      response.status = 204
    end

  end

  def active

    obj = TimeSession.find_by(end: nil)

    p obj

    if obj.nil?
      response.status = 404
      render json: {}
    else
      response.status = 200
      render json: obj
    end

  end

  def destroy

    begin
      obj = TimeSession.find(params[:id])
      obj.destroy
      response.status = 204
    rescue ActiveRecord::RecordNotFound => e
      response.status = 404
      render json: {}
    rescue Exception => e
      response.status = 500
      render json: {}
    end

  end

end
