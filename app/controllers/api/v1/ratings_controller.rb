class Api::V1::RatingsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    average = Rating.create_rating(params[:post_id], params[:user_id], params[:value])
    render json: { average_rating: average }
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end
end
