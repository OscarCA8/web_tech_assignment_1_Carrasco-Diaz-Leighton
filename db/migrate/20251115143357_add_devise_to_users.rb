# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      ## Database authenticatable
      # Allow NULL emails for existing users; Devise will still require email for *new* users
      t.string :email

      # keep encrypted_password strict, that's fine
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      # (keep the rest of whatever Devise added, if there is more)
    end

    # Unique index only for rows where email IS NOT NULL
    add_index :users, :email, unique: true, where: "email IS NOT NULL"
    add_index :users, :reset_password_token, unique: true
  end
end