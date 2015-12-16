class CreateMarks < ActiveRecord::Migration
  def change
    create_table :marks do |t|
      t.integer :user_liking_id
      t.integer :user_liked_id
      t.integer :mark

      t.timestamps null: false
    end
  end
end
