class Api::V1::RatingsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    post = Post.find(params[:post_id])
    user = User.find(params[:user_id])

    rating = post.ratings.new(user: user, value: params[:value])

    if rating.save
      average = post.ratings.average(:value).to_f.round(2)
      render json: { average_rating: average }
    else
      render json: { errors: rating.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Post/User not found" }, status: :not_found
  rescue ActiveRecord::RecordNotUnique
    render json: { error: "You've already rated this post" }, status: :conflict
  end
end
