class CreateGroupMembers < ActiveRecord::Migration
  def change
    create_table :group_members do |t|
      t.belongs_to :group, index: true
      t.belongs_to :member, index: true

      t.timestamps null: false
    end
    add_foreign_key :group_members, :groups
    add_foreign_key :group_members, :members
  end
end
