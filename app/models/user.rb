class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable,
         :invitable #, invite_for: 2.weeks # the period the generated invitation token is valid

  enum role: { volunteer: 0, moderator: 1, admin: 2 }

  scope :volunteers, -> { where(role: :volunteer) }
end
