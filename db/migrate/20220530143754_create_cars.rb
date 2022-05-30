class CreateCars < ActiveRecord::Migration[6.1]
  def change
    create_table :cars do |t|
      t.string :car_model
      t.references :user, null: false, foreign_key: true
      t.string :color

      t.timestamps
    end
  end
end
