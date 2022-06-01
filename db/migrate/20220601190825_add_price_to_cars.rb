class AddPriceToCars < ActiveRecord::Migration[6.1]
  def change
    add_column :cars, :price, :float
  end
end
