class HelpRequestKind < ApplicationRecord
  belongs_to :organization

  validates :organization, :name, presence: true
  validates :name, uniqueness: { scope: :organization_id }

end
