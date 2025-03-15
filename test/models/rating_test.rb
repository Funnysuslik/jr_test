require "test_helper"

class RatingTest < ActiveSupport::TestCase
  def setup
    @user = User.create(login: "testuser")
    @post = Post.create(user: @user, title: "Test Title", body: "Test Body", ip: "127.0.0.1")
    @rating = Rating.new(user: @user, post: @post, value: 3)
  end

  test "should be valid" do
    assert @rating.valid?
  end

  test "value should be present" do
    @rating.value = nil
    assert_not @rating.valid?
  end

  test "value should be between 1 and 5" do
    @rating.value = 6
    assert_not @rating.valid?
    @rating.value = 0
    assert_not @rating.valid?
  end

  test "user should be present" do
    @rating.user = nil
    assert_not @rating.valid?
  end

  test "post should be present" do
    @rating.post = nil
    assert_not @rating.valid?
  end
end
