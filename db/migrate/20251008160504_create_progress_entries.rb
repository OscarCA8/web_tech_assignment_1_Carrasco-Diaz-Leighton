class CreateProgressEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :progress_entries do |t|
      t.references :challenge, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.integer :points
      t.text :description

      t.timestamps
    end
    add_index :progress_entries, [:challenge_id, :user_id, :date]
  end
end
