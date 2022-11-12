class RemoveUsersEmailIndex < ActiveRecord::Migration[6.1]
  def change
    remove_index :users, :email
  end
end
