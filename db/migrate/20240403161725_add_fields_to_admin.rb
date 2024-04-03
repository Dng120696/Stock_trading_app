class AddFieldsToAdmin < ActiveRecord::Migration[7.1]
  def change
    add_column :admin_users, :firstname, :string
    add_column :admin_users, :lastname, :string
    add_column :admin_users, :role, :integer,default: 0
  end
end
