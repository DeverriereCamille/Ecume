class AddUnlockingKeyToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :unlocking_key, :string
  end
end
