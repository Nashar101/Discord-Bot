class AddSteamIdToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :steam_id, :bigint
  end
end
