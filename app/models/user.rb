class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable,
         :invitable, # , invite_for: 2.weeks # the period the generated invitation token is valid
         :registerable, :confirmable
  belongs_to :organization, optional: true # TODO: add conditions = true only admin

  include RolesHelpers
  include MobileDevices

  has_many :activity, -> { reorder('created_at DESC') }, class_name: 'HelpRequestLog'

  paginates_per 20

  validates :organization_id, presence: true, if: -> { moderator? || volunteer? }

  enum status: { active: 0, pending: 1, blocked: 2 } do
    event :block do
      transition all => :blocked
    end

    event :approve do
      transition pending: :active
    end
  end

  def active_for_authentication?
    super && account_active?
  end

  def account_active?
    organization ? !organization.archive? : true
  end

  def to_s
    # TODO: add name fields
    [email].join(' ')
  end
end
