class AddActiveToMembers < ActiveRecord::Migration
  def change
    add_column :members, :active, :boolean, null: false, default: true
  end
end
