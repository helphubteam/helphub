class DivideRequestAddressField < ActiveRecord::Migration[6.0]
  def change
    add_column :help_requests, :city, :string
    add_column :help_requests, :district, :string
    add_column :help_requests, :street, :string
    add_column :help_requests, :house, :string
    add_column :help_requests, :apartment, :string
    remove_column :help_requests, :address, :string
  end
end
