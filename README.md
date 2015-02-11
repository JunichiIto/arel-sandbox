## Arel Sandbox

Sandbox app for http://qiita.com/necojackarc/items/2121dc1638ad1766fd74

## SQL examples

```sql
-- e = Event.create
-- puts Member.active_record_no_participation_in(e).to_sql
SELECT "members"."id"         AS t0_r0,
       "members"."name"       AS t0_r1,
       "members"."created_at" AS t0_r2,
       "members"."updated_at" AS t0_r3,
       "members"."active"     AS t0_r4,
       "groups"."id"          AS t1_r0,
       "groups"."name"        AS t1_r1,
       "groups"."event_id"    AS t1_r2,
       "groups"."created_at"  AS t1_r3,
       "groups"."updated_at"  AS t1_r4
FROM   "members"
       LEFT OUTER JOIN "group_members"
                    ON "group_members"."member_id" = "members"."id"
       LEFT OUTER JOIN "groups"
                    ON "groups"."id" = "group_members"."group_id"
WHERE  ( groups.event_id != 3
          OR groups.event_id IS NULL )

-- puts Member.squeel_no_participation_in(e).to_sql
SELECT DISTINCT "members".*
FROM   "members"
       LEFT OUTER JOIN "group_members"
                    ON "group_members"."member_id" = "members"."id"
       LEFT OUTER JOIN "groups"
                    ON "groups"."id" = "group_members"."group_id"
WHERE  ( "groups"."event_id" != 3
          OR "groups"."event_id" IS NULL )

-- puts Member.sql_no_participation_in(e).to_sql
SELECT "members".*
FROM   "members"
WHERE  ( NOT EXISTS (SELECT *
                     FROM   groups b
                            JOIN group_members c
                              ON b.id = c.group_id
                                 AND b.event_id = 3
                     WHERE  members.id = c.member_id) )

-- puts Member.arel_no_participation_in(e).to_sql
SELECT "members".*
FROM   "members"
WHERE  ( NOT ( EXISTS (SELECT *
                       FROM   "groups"
                              INNER JOIN "group_members"
                                      ON "groups"."id" =
                                         "group_members"."group_id"
                                         AND "groups"."event_id" = 3
                       WHERE  "members"."id" = "group_members"."member_id") ) )

```