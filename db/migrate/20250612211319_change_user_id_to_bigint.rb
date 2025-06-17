class ChangeUserIdToBigint < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :user_id, :bigint
  end
end
