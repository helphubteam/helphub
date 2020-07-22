class AddDefaultToHelpRequestKinds < ActiveRecord::Migration[6.0]
  def change
    add_column :help_request_kinds, :default, :boolean, default: false, null: false
  end
end
