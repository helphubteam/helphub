class AddSheduleSetAtToHelpRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :help_requests, :schedule_set_at, :date
  end
end
