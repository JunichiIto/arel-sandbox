class Member < ActiveRecord::Base
  has_many :group_members
  has_many :groups, through: :group_members

  def self.not_joined_to(event)
    members = Member.arel_table
    groups = Group.arel_table
    groups_members = GroupMember.arel_table

    condition =
        groups
            .project(Arel.star)
            .join(groups_members)
            .on(groups[:id].eq(groups_members[:group_id]), groups[:event_id].eq(event.id))
            .where(members[:id].eq(groups_members[:member_id]))

    Member.where(condition.exists.not).all
  end
end
