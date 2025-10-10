class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.date :birthday
      t.string :nationality
      t.string :gender
      t.boolean :is_admin

      t.timestamps
    end
  end
end
