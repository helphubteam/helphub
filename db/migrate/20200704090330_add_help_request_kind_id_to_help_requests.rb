class AddHelpRequestKindIdToHelpRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :help_requests, :help_request_kind_id, :integer
  end
end
