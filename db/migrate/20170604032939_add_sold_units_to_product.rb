class AddSoldUnitsToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :sold_units, :integer, default: 0
  end
end
