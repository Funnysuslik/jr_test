class Api::V1::PostsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    limit = (params[:n] || 10).to_i
    @posts = Post.left_joins(:ratings)
                 .select('posts.*, COALESCE(AVG(ratings.value), 0) as avg_rating')
                 .group('posts.id')
                 .order('avg_rating DESC')
                 .limit(limit)

    render json: @posts.as_json(only: [:id, :title, :body])
  end

  def create
    user = User.find_or_initialize_by(login: params[:user_login])
    user.save! if user.new_record?

    post = Post.new(
      title: params[:title],
      body: params[:body],
      user: user,
      ip: params[:ip], # request.remote_ip
    )

    if post.title.nil? || post.body.nil?
      render json: { errors: ["Title and body can't be blank"] }, status: :unprocessable_entity
    elsif post.save
      render json: post.as_json(include: :user), status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def ip_list
    results = Post.joins(:user)
                  .group(:ip)
                  .select('ip, array_agg(distinct users.login) as authors')
                  .having('count(distinct user_id) > 1')
                  .map { |p| { ip: p.ip, authors: p.authors } }

    render json: results
  end
end
