class ChangecolumnAssignedTo < ActiveRecord::Migration
  def self.up
    change_column :issues, :assigned_to,:integer
  end

  def self.down
  end
end
