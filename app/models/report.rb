# == Schema Information
#
# Table name: reports
#
#  id              :bigint           not null, primary key
#  condition       :hstore
#  document        :string
#  name            :string
#  state           :integer          default("enqueued"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#
# Indexes
#
#  index_reports_on_organization_id  (organization_id)
#
class Report < ApplicationRecord
  belongs_to :organization

  paginates_per 20

  enum state: { enqueued: 0, processing: 1, finished: 2, errored: 3 } do
    event :process do
      transition enqueued: :processing
    end

    event :finish do
      transition processing: :finished
    end

    event :break do
      transition all => :errored
    end
  end
end
