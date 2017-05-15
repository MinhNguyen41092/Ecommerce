class AddRatingsToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :ratings, :decimal, default: 1
  end
end
