class AddLongLatAddressToCars < ActiveRecord::Migration[6.1]
  def change
    add_column :cars, :address, :string
    add_column :cars, :lat, :float
    add_column :cars, :long, :float
  end
end
