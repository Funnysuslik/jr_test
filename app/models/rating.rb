class Rating < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :value,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 5
    }
  validates :user_id,
    uniqueness: { scope: :post_id }

  def self.create_rating(post_id, user_id, value)
    post = Post.find(post_id)
    user = User.find(user_id)

    Rating.transaction do
      Rating.where(post_id: post_id, user_id: user_id).lock(true)

      rating = post.ratings.create!(user: user, value: value)
      post.ratings.average(:value).to_f.round(2)
    end
  end
end
