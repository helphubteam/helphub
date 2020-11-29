class AddActivatedAtToHelpRequest < ActiveRecord::Migration[6.0]
  def up
    add_column :help_requests, :activated_at, :date

    HelpRequest.where(state: :active).find_each do |record|
      record.activated_at = record.created_at
      record.save
    end
  end

  def down
    remove_column :help_requests, :activated_at
  end
end
