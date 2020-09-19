class AddTitleToHelpRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :help_requests, :title, :string, limit: 140
  end
end
