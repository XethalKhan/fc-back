class ApplicationController < ActionController::Base

  # Return LoginSession if token is valid and session has not expired.
  # Otherwise, return nil.
  def validate_session(token)

    obj = LoginSession.find_by(token: token)

    if obj.nil?
      return nil
    end

    unless obj.valid_token
      return nil
    end

    return obj

  end

end
