class RemoveUserIdFromMeetups < ActiveRecord::Migration
  def up
    remove_column :meetups, :user_id
  end

  def down
    change_table :meetups do |t|
      t.belongs_to :user, null: false, default: 0
    end
  end
end
