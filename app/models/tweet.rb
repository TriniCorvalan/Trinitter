class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes
  validates :content, presence: true

  def liked?(user)
    !!self.likes.find{|like| like.user_id == user.id}
  end

  def likes_count
    self.likes.count
  end

end
