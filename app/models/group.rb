class Group < ActiveRecord::Base
  belongs_to :event
  has_many :group_members
  has_many :members, through: :group_members
end
