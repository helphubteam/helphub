class AddVolunteerIdToHelpRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :help_requests, :volunteer_id, :integer
  end
end
