class CreateMeetups < ActiveRecord::Migration
  def change
    create_table :meetups do |t|
      t.belongs_to :user, null: false
      t.string :name, null: false
      t.string :description, null: false
      t.string :location, null: false

      t.timestamps null: false
    end

    add_index :meetups, :name, unique: true
  end
end
