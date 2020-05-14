class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :validatable

  enum role: { volunteer: 0, moderator: 1, admin: 2 }

  scope :volunteers, -> { where(role: :volunteer) }
end
