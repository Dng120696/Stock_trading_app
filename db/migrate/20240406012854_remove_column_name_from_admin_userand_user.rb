class RemoveColumnNameFromAdminUserandUser < ActiveRecord::Migration[7.1]
  def change
    remove_column :admin_users, :role, :integer
    remove_column :users, :role, :integer
  end
end
