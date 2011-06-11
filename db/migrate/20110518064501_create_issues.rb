class CreateIssues < ActiveRecord::Migration
  def self.up
    create_table :issues do |t|
      t.string :short_description
      t.text :detailed_description
      t.string :status
      t.string :issue_type
      t.integer :assigned_to
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :issues
  end
end
