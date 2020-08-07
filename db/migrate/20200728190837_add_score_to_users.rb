class AddScoreToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :score, :integer, default: 0, null: false
  end
end
