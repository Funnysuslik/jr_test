require 'test_helper'

class Api::V1::RatingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(login: 'user_one')
    @post = Post.create!(title: 'New Post', body: 'Post body', user: @user, ip: '127.0.0.1')
  end

  test "should create rating" do
    assert_difference('Rating.count') do
      post api_v1_ratings_url, params: { post_id: @post.id, user_id: @user.id, value: 5 }
    end
    assert_response :success
    assert_includes response.body, 'average_rating'
  end

  test "should not create rating with invalid data" do
    post api_v1_ratings_url, params: { post_id: @post.id, user_id: @user.id, value: nil }
    assert_response :unprocessable_entity
  end

  test "should handle post/user not found" do
    post api_v1_ratings_url, params: { post_id: -1, user_id: -1, value: 5 }
    assert_response :not_found
  end

  test "should handle duplicate rating" do
    post api_v1_ratings_url, params: { post_id: @post.id, user_id: @user.id, value: 5 }
    post api_v1_ratings_url, params: { post_id: @post.id, user_id: @user.id, value: 5 }
    assert_response :unprocessable_entity
  end
end
