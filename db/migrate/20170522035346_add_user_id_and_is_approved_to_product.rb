class AddUserIdAndIsApprovedToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :user_id, :integer
    add_column :products, :is_approved, :boolean
  end
end
