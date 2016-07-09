class Product < ActiveRecord::Base
  belongs_to :user
  has_many :sales
  has_attached_file :file

  validates_numericality_of :price,
    greater_than: 50,
    message: "price must be greater than 50 cents"

  validates_attachment :file,
    presence: true,
    size: { less_than: 2.megabytes },
    content_type: {
      content_type: [
        "image/jpg",
        "image/jpeg",
        "image/png",
        "image/gif",
        "application/pdf",
        "application/zip"
      ]
    }
end
