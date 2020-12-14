class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes
  belongs_to :tweet, class_name: 'Tweet', optional: true
  has_many :tweets, foreign_key: :tweet_id, class_name: 'Tweet'
  validates :content, presence: true

  def liked?(user)
    !!self.likes.find{|like| like.user_id == user.id}
  end

  def likes_count
    self.likes.count
  end

end
