class AddNameToChatroom < ActiveRecord::Migration[5.0]
  def change
    add_column :chatrooms, :name, :string
  end
end
