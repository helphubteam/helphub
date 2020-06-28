class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable,
         :invitable # , invite_for: 2.weeks # the period the generated invitation token is valid
  belongs_to :organization, optional: true # TODO: add conditions = true only admin

  enum role: { volunteer: 0, moderator: 1, admin: 2 }

  scope :volunteers, -> { where(role: :volunteer) }
  scope :moderators, -> { where(role: :moderator) }

  validates :role, presence: true

  has_many :activity, -> { reorder('created_at DESC') }, class_name: 'HelpRequestLog'

  paginates_per 20
end
