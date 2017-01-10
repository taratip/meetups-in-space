class AddReferenceCreatorToMeetups < ActiveRecord::Migration
  def up
      add_reference :meetups, :creator, references: :users, index: true, null: false, default: 1
      add_foreign_key :meetups, :users, column: :creator_id
  end

  def down
      remove_foreign_key :meetups, :creator
      remove_reference :meetups, :creator, references: :users
  end
end
