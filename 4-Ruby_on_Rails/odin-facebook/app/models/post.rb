class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, as: :likeable
  has_many :comments

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true
  validate  :picture_size

  private
  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end