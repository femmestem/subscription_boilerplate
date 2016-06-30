class Product < ActiveRecord::Base
  belongs_to :user
  has_many :sales

  has_attached_file :file
end
