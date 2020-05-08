class ChangeUsersColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :banner_image, :string
    add_column :users, :github, :string
  end
end
