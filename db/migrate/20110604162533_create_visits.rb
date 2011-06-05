class CreateVisits < ActiveRecord::Migration
  def self.up
    create_table :visits do |t|
      t.integer :user_id
      t.integer :issue_id
      t.datetime :visited_at
    end
  end

  def self.down
  end
end
