class AddfieldtoAdmin < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :firstname, :string
    add_column :admins, :lastname, :string
    add_column :admins, :role, :integer,default: 0
  end
end
