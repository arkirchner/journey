class UnprocessedImage < ApplicationRecord
  after_create :process
  belongs_to :user
  has_one_attached :image

  scope :with_user, ->(user) { where(user: user) }

  def processed?
    position_processed?
  end

  private

  def process
    ImageLocationDetectionJob.perform_later(id)
  end
end
