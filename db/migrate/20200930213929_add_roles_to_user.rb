class TargetModel < ActiveRecord::Base
  self.table_name = 'users'
  enum role: { volunteer: 0, moderator: 1, admin: 2 }
end

class AddRolesToUser < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :roles, :hstore

    TargetModel.all.find_each do |user|
      roles = {}
      roles[user.role.to_s] = true
      user.roles = roles
      user.save
    end

    rename_column :users, :role, :old_role
  end

  def down
    rename_column :users, :old_role, :role
    remove_column :users, :roles
  end
end
