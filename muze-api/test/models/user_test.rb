require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "should not save post without title" do
    user = User.new
    assert user.save, "Saved the user with a title"
  end
end


