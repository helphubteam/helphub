class HelpRequestLog < ApplicationRecord
  belongs_to :user
  belongs_to :help_request

  enum kind: {
    actived: 0, assigned: 1,
    submitted: 2, refused: 3,
    blocked: 4, activated: 5,
    refreshed: 6, created: 7
  }

  validates :kind, presence: true
end
