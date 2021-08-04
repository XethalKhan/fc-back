class TimeSession < ApplicationRecord

  #TODO: Add validation, end date can't be lower than start date.

  # Relation, one session can belong to one user.
  belongs_to :user

end
