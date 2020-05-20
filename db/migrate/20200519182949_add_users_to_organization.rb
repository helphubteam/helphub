class AddUsersToOrganization < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :organization, foreign_key: true
  end
end
