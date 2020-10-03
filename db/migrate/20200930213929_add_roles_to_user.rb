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

    remove_column :users, :role
  end

  def down
    add_column :users, :role, :integer, default: 0, null: false

    TargetModel.all.find_each do |user|
      user.role = user.roles.find{|k, v| v }[0].to_sym
      user.save
    end

    remove_column :users, :roles
  end
end
