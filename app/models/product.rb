class Product < ActiveRecord::Base
  belongs_to :user
  has_many :sales

  validates_numericality_of :price,
    greater_than: 0,
    message: "price must be greater than 0"

  has_attached_file :file

  validates_attachment_content_type :file, :content_type => [
    "image/jpg",
    "image/jpeg",
    "image/png",
    "image/gif",
    "application/pdf",
    "application/zip"
  ]
end
