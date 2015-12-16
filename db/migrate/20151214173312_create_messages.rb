class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :message_id
      t.integer :conversation_id
      t.integer :author_id
      t.text :content

      t.timestamps null: false
    end
  end
end
