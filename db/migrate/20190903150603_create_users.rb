class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :user_id, null: false
      t.string :provider, null: false
      t.string :name, null: false
      t.string :email

      t.timestamps
    end

    add_index :users, %i[user_id provider], unique: true
    add_index :users, :email, unique: true
  end
end
