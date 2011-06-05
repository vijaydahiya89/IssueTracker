class RemoveVisitedAtFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :visited_at
  end

  def self.down
  end
end
