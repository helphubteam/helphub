class TmpUser < ActiveRecord::Base
  self.table_name = 'users'
end

class AddConfirmPolicyToUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :policy_confirmed, :boolean
    TmpUser.update_all(policy_confirmed: true)
  end

  def down
    add_column :users, :policy_confirmed, :boolean
  end
end
