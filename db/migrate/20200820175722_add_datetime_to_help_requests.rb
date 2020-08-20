class AddDatetimeToHelpRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :help_requests, :date_begin, :datetime
    add_column :help_requests, :date_end, :datetime
  end
end
