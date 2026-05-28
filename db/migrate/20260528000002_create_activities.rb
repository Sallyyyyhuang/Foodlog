class CreateActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :activities do |t|
      t.string :activity_type
      t.integer :duration_minutes
      t.integer :steps
      t.integer :calories_burned
      t.datetime :logged_at

      t.timestamps
    end
  end
end
