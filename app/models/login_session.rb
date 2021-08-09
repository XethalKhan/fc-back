class LoginSession < ApplicationRecord

  #Validation, what fields must be present
  validates :token, :start, :last_activity, presence: true

  # Relation, one session can belong to one user.
  belongs_to :user

  # Class variable that defines how long can login session last without activity.
  # Value in minutes.
  # TODO: place in some sort of config file
  @@TOKEN_DURATION = 15

  # Validation, password must be stored as SHA256.
  # validates :token, format: {
  #   with: /\A\b[A-Fa-f0-9]{64}\b\z/,
  #   message: "Store token as SHA256!"
  # }

  # Check if token is valid.
  # Return true if token is valid. Else return false.
  # QUESTION: Maybe we should seperate updating od columns end and last_activity
  # into seperate methods?
  def valid_token

    if(!self.end.nil?)
      return false
    end

    current = Time.new

    difference = ((current - self.last_activity) / 60).floor

    if(difference >= @@TOKEN_DURATION)
      self.end = current
      self.save
      return false;
    end

    self.last_activity = current
    self.save

    return true

  end

  def define_response

    return {
      token: self.token,
      user: self.user.define_response
      }

  end

end
