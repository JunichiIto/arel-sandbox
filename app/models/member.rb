class Member < ActiveRecord::Base
  has_many :group_members
  has_many :groups, through: :group_members

  # FIXME 対応できないパターンがある
  scope :active_record_no_participation_in, ->(event) { includes(:groups).references(:groups).where("groups.event_id != ? OR groups.event_id IS NULL", event.id) }

  # FIXME 対応できないパターンがある
  scope :squeel_no_participation_in, ->(event) { joins{groups.outer}.where{ (groups.event_id != event.id) | (groups.event_id == nil) }.uniq }

  scope :sql_no_participation_in, ->(event) do
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

  scope :arel_no_participation_in, ->(event) do
    members = Member.arel_table
    groups = Group.arel_table
    group_members = GroupMember.arel_table

    condition =
        groups
            .project(Arel.star)
            .join(group_members)
            .on(groups[:id].eq(group_members[:group_id]), groups[:event_id].eq(event.id))
            .where(members[:id].eq(group_members[:member_id]))
    where{condition.exists.not}
  end

  scope :two_queries_no_participation_in, ->(event) do
    ids_to_exclude = Member.joins(:groups).where(groups: {event_id: event.id}).pluck(:id)
    where.not(id: ids_to_exclude)
  end

  scope :active, ->{ where(active: true) }
end
