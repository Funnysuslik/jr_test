require "test_helper"

class PostTest < ActiveSupport::TestCase
  def setup
    @user = User.create(login: "testuser")
    @post = Post.new(user: @user, title: "Test Title", body: "Test Body", ip: "127.0.0.1")
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "title should be present" do
    @post.title = " "
    assert_not @post.valid?
  end

  test "body should be present" do
    @post.body = " "
    assert_not @post.valid?
  end

  test "ip should be present" do
    @post.ip = " "
    assert_not @post.valid?
  end

  test "user should be present" do
    @post.user = nil
    assert_not @post.valid?
  end
end
