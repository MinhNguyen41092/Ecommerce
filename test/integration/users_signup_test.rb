require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get new_user_path
    assert_difference 'User.count', 0 do
      post users_path, params: { user: { name: "", email: "",
                                        password: "", password_confirmation: "" } }
    end
    assert_template "users/new"
  end

  test "valid signup information" do
    get new_user_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "dinh minh", email: "abc@example.com",
                                        password: "password", password_confirmation: "password" } }
    end
    assert_not flash.empty?
    assert_redirected_to root_path
    assert is_logged_in?
  end
end
