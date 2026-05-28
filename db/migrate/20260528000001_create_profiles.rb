class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.string :gender
      t.integer :age
      t.decimal :weight_kg, precision: 6, scale: 2
      t.decimal :height_cm, precision: 6, scale: 2
      t.string :activity_level

      t.timestamps
    end
  end
end
