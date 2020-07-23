class AddScoreToHelpRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :help_requests, :score, :integer, default: 1, null: false
  end
end
