class AddHelpRequestsToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_reference :help_requests, :organization, foreign_key: true
  end
end
