class CreateChallengeBadges < ActiveRecord::Migration[8.0]
  def change
    create_table :challenge_badges do |t|
      t.references :challenge, null: false, foreign_key: true
      t.references :badge, null: false, foreign_key: true
      t.text :requirement

      t.timestamps
    end
    add_index :challenge_badges, [:challenge_id, :badge_id], unique: true
  end
end
