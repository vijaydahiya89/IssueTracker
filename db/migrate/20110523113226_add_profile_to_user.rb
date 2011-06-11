class AddProfileToUser < ActiveRecord::Migration
  def self.up
    add_column  :users, :profile_file_name, :string
    add_column  :users, :profile_content_type, :string
    add_column  :users, :profile_file_size, :integer
  end

  def self.down
  end
end
