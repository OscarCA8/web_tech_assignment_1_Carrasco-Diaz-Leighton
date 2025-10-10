class CreateParticipations < ActiveRecord::Migration[8.0]
  def change
    create_table :participations do |t|
      t.references :challenge, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :points
      t.date :date_start

      t.timestamps
    end
    add_index :participations, [:challenge_id, :user_id], unique: true
  end
end
