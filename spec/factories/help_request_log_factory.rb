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
FactoryBot.define do
  factory :help_request_log do
    user
    help_request
    kind { :created }
  end
end
