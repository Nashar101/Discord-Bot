class GenerateBasicUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, primary_key: [:user_id] do |t|
      t.integer :user_id, null: false
      t.string :valorant_id, null: true

      t.timestamps
    end
  end
end
