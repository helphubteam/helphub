class CreateHelpRequestLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :help_request_logs do |t|
      t.text :comment
      t.references :help_request, null: false
      t.integer :kind, null: false
      t.references :user, null: false
      t.timestamps
    end
  end
end
