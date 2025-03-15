require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(login: "testuser")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "login should be present" do
    @user.login = ""
    assert_not @user.valid?
  end
end
