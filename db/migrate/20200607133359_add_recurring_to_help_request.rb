class AddRecurringToHelpRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :help_requests, :recurring, :boolean
  end
end
