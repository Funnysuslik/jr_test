class Api::V1::PostsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    limit = (params[:n] || 10).to_i
    @posts = Post.top_rated(limit) # Assign @posts explicitly
    render json: @posts.as_json(only: [ :id, :title, :body ])
  end

  def create
    post = Post.create_post(params)
    if post.persisted?
      render json: post.as_json(include: :user), status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def ip_list
    results = Post.authors_with_shared_ips
    render json: results
  end
end
