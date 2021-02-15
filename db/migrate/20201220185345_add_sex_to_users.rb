class AddSexToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :sex, :integer
  end
end
