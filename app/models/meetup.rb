class Meetup < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'creator_id', class_name: "User"
  has_one :meeting
  has_many :users, :through => :meeting

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :location, presence: true, length: { maximum: 150 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :creator, presence: true
end
