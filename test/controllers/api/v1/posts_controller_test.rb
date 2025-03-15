require "test_helper"

class Api::V1::PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(login: "user_one")
    @post = Post.create!(title: "New Post", body: "Post body", user: @user, ip: "127.0.0.1")
  end

  test "should create post" do
    assert_difference("Post.count") do
      post api_v1_posts_url, params: { title: "New Post", body: "Post body", user_login: "user_one", ip: "127.0.0.1" }
    end
    assert_response :created
  end

  test "should get index" do
    get api_v1_posts_url
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should not create post with invalid data" do
    post api_v1_posts_url, params: { title: nil, body: nil, user_login: "user_one", ip: "127.0.0.1" }
    assert_response :unprocessable_entity
  end

  test "should get ip_list" do
    get "/api/v1/posts/ips"
    assert_response :success
  end
end
