class Member < ActiveRecord::Base
  has_many :group_members
  has_many :groups, through: :group_members

  scope :scope_not_joined_to, ->(event) { includes(:groups).references(:groups).where("groups.event_id != ? OR groups.event_id IS NULL", event.id) }
  scope :squeel_not_joined_to, ->(event) { joins{groups.outer}.where{ (groups.event_id != event.id) | (groups.event_id == nil) } }
  scope :sql_not_joined_to, ->(event) do
    where(<<-SQL, event.id)
NOT EXISTS
    (SELECT * FROM groups b
                JOIN group_members c
                  ON b.id = c.group_id AND
                     b.event_id = ?
              WHERE
                members.id = c.member_id)
    SQL
  end

  scope :active, ->{ where(active: true) }

  def self.not_joined_to(event)
    members = Member.arel_table
    groups = Group.arel_table
    group_members = GroupMember.arel_table

    condition =
        groups
            .project(Arel.star)
            .join(group_members)
            .on(groups[:id].eq(group_members[:group_id]), groups[:event_id].eq(event.id))
            .where(members[:id].eq(group_members[:member_id]))

    Member.where(condition.exists.not).all
  end
end
