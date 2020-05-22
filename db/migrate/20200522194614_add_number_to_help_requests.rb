class AddNumberToHelpRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :help_requests, :number, :string
  end
end
