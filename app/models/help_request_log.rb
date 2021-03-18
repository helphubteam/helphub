class HelpRequestLog < ApplicationRecord
  belongs_to :user
  belongs_to :help_request

  enum kind: {
    actived: 0, assigned: 1,
    submitted: 2, refused: 3,
    blocked: 4, activated: 5,
    refreshed: 6, created: 7,
    manual_unassign: 8,
    manual_assign: 9,
    updated: 10
  }

  validates :kind, presence: true
end
