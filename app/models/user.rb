require "digest"

class User < ApplicationRecord

  #Validation, what fields must be present
  validates :full_name, :email, :password, presence: true

  # Relation, one user can have many login sessions.
  # User can have only one active login session.
  # That session has end date equal to nil.
  has_many :login_sessions

  # Relation, one user can have many time sessions.
  # User can have only one active time session.
  # That session has end date equal to nil.
  has_many :time_sessions

  # Validation, email must satisfy specific form.
  # Regex found on https://www.emailregex.com/
  validates :email, format: { with: /\A[A-Z0-9._%-]+@[A-Z0-9._%-]+\.[A-Z]{2,4}\z/i, message: "Bad e-mail format" }

  # Validation, password must be stored as SHA256.
  # See https://regex101.com/r/AXhQLz/1
  validates :password, format: {
    with: /\A\b[A-Fa-f0-9]{64}\b\z/,
    message: "DO NOT STORE PLAIN TEXT PASSWORDS IN DB!"
  }

  #Start session for a user
  def login

    dateObj = Time.new

    token = Digest::SHA256.hexdigest(self.email + dateObj.to_s + self.full_name)

    new_session = self.login_sessions.create(
      token: token,
      start: dateObj,
      last_activity: dateObj
    )

    return new_session

  end

  #Check if user is already logged in. Return boolean.
  def is_active

    active_session = self.login_sessions.where(end: nil)

    if active_session.empty?
      return false
    end

    if active_session.first.valid_token
      return true
    end

    return false

  end

  # Get users current active session.
  def active_session
    return self.login_sessions.where(end: nil);
  end

  def define_response
    return {id: self.id, full_name: self.full_name, email: self.email}
  end

end
