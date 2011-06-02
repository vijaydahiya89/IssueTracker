class AddColumnToIssueIssueType < ActiveRecord::Migration
  def self.up
    add_column  :issues, :issue_type, :string
  end

  def self.down
  end
end
