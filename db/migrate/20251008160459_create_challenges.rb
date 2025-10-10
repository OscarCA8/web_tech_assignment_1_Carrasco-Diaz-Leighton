class CreateChallenges < ActiveRecord::Migration[8.0]
  def change
    create_table :challenges do |t|
      t.string :name
      t.text :description
      t.date :start_day
      t.date :end_day
      t.text :point_rules
      t.references :creator, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
