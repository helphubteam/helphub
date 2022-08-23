# == Schema Information
#
# Table name: help_request_logs
#
#  id              :bigint           not null, primary key
#  comment         :text
#  kind            :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  help_request_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_help_request_logs_on_help_request_id  (help_request_id)
#  index_help_request_logs_on_user_id          (user_id)
#
class HelpRequestLog < ApplicationRecord
  belongs_to :user
  belongs_to :help_request
  
  has_many_attached :photos do |attachment|
    attachable.variant :thumb, resize: "100x100"
    attachable.variant :medium, resize: "300x300", monochrome: true  
  end

  validates :photos, presence: false, blob: { content_type: ['image/bmp', 'image/png', 'image/jpg', 'image/jpeg'], size_range: 0..(10.megabytes) }

  enum kind: {
    actived: 0, assigned: 1,
    submitted: 2, refused: 3,
    blocked: 4, activated: 5,
    refreshed: 6, created: 7,
    manual_unassign: 8,
    manual_assign: 9,
    updated: 10,
    cloned: 11
  }

  validates :kind, presence: true

  def label
    user_role = I18n.t("activerecord.attributes.user.#{self.user.role}")
    I18n.t("help_request_log.kind.#{self.kind}", user: user_role)
  end
end
