class Issue < ActiveRecord::Base
  has_attached_file :image, :styles => { :medium => "600x600>" }
  belongs_to  :user
  belongs_to  :post
end
