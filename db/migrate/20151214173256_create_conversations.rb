class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :conversation_id
      t.integer :transmitter_id
      t.integer :recepteur_id
      t.boolean :finished
      t.boolean :published_by_transmitter
      t.boolean :published_by_recepteur

      t.timestamps null: false
    end
  end
end
