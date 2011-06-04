class AddCloumnForVisitedAt < ActiveRecord::Migration
  def self.up
    add_column  :users, :visited_at, :datetime
  end

  def self.down
  end
end
