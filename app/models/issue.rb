class Issue < ActiveRecord::Base
  has_attached_file :image, :styles => { :medium => "728x728>" }
  belongs_to  :user
  belongs_to  :post
end
