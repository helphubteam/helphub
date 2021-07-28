class TargetModelLog < ActiveRecord::Base
  self.table_name = 'help_request_logs'
end

class TargetModel < ActiveRecord::Base
  self.table_name = 'help_requests'
  has_many :logs, -> { reorder('created_at DESC') }, foreign_key: "help_request_id", class_name: 'TargetModelLog'
end

class AddCreatorIdToHelpRequests < ActiveRecord::Migration[6.1]
  def up
    add_column :help_requests, :creator_id, :integer

    TargetModel.find_each do |hr|
      hr.creator_id = hr.logs.first.try(:user_id)
      hr.save
    end
  end

  def down
    remove_column :help_requests, :creator_id
  end
end
