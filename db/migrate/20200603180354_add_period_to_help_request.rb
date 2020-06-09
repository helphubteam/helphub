class AddPeriodToHelpRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :help_requests, :period, :integer
  end
end
