class CreateJoinTableMeetupsUsers < ActiveRecord::Migration
  def up
    create_join_table :users, :meetups, table_name: :meetings
  end

  def down
    drop_join_table :users, :meetups, table_name: :meetings
  end
end
