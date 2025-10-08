class CreateBadges < ActiveRecord::Migration[8.0]
  def change
    create_table :badges do |t|
      t.string :name
      t.string :logo
      t.string :badge_type
      t.text :description
      t.text :requirement

      t.timestamps
    end
  end
end
