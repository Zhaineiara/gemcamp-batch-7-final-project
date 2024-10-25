class AddFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username, :string
    add_column :users, :role, :string
    add_column :users, :phone, :string
    add_column :users, :coins, :integer
    add_column :users, :total_deposit, :decimal
    add_column :users, :children_members, :integer
  end
end
