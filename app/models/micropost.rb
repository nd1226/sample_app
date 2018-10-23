class Micropost < ApplicationRecord
  belongs_to :user
  scope :create_at, ->{order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.maximum_content}
  validate  :picture_size

  private
  def picture_size
    return unless picture.size > Settings.micropost.size_piture
    errors.add(:picture, t("micropost.picture_size"))
  end
end
