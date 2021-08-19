# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  app_version            :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  device_platform        :string
#  device_token           :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invited_by_type        :string
#  name                   :string
#  old_role               :integer          default(0), not null
#  phone                  :string
#  policy_confirmed       :boolean
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  roles                  :hstore
#  score                  :integer          default(0), not null
#  sex                    :integer
#  status                 :integer          default("active")
#  surname                :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :integer
#  organization_id        :bigint
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_organization_id       (organization_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable,
         :invitable, # , invite_for: 2.weeks # the period the generated invitation token is valid
         :registerable, :confirmable
  belongs_to :organization, optional: true # TODO: add conditions = true only admin

  after_invitation_accepted :notify_moderators

  include RolesHelpers
  include MobileDevices

  has_many :activity, -> { reorder('created_at DESC') }, class_name: 'HelpRequestLog'

  paginates_per 20

  validates :organization_id, presence: true, if: -> { moderator? || volunteer? }

  validates :name, :surname, presence: true, if: :volunteer?
  validates :phone, presence: true, if: -> { new_record? && volunteer? }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :policy_confirmed, presence: true, if: :volunteer?

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

  def after_confirmation
    notify_moderators
  end

  def notify_moderators
    ::NewVolunteerNotificationWorker.perform_async(id)
  end
end
