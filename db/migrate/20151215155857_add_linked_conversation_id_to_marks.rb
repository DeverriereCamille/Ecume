class AddLinkedConversationIdToMarks < ActiveRecord::Migration
  def change
    add_column :marks, :linked_conversation_id, :int
  end
end
