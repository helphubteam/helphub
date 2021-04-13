class TmpUser < ActiveRecord::Base
  self.table_name = 'users'
end

class AddFieldsToUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string

    # Confirm all existing users
    TmpUser.update_all(confirmed_at: Time.zone.now, confirmation_sent_at: Time.zone.now)
  end

  def down
    remove_column :users, :confirmation_token, :string
    remove_column :users, :confirmed_at, :datetime
    remove_column :users, :confirmation_sent_at, :datetime
    remove_column :users, :unconfirmed_email, :string
  end
end
