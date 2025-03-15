class Api::V1::RatingsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    post = Post.find(params[:post_id])
    user = User.find(params[:user_id])

    rating = post.ratings.new(user: user, value: params[:value])

    rating.save!
    average = post.ratings.average(:value).to_f.round(2)
    render json: { average_rating: average }
  end
end
