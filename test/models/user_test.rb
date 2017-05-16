require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
  	@user = User.new(name:"Dinh Minh", email:"exp@example.com",
                      password:"dinhminh", password_confirmation:"dinhminh")
  end

  test "should be valid" do
  	assert @user.valid?
  end

  test "name should be present" do
  	@user.name = " "
  	assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a"*51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a"*256
    assert_not @user.valid?
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase!
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be downcased before saved" do
    test_email = "MINH@GMAIL.COM"
    @user.email = test_email
    @user.save
    assert_equal test_email.downcase, @user.email
  end

  test "password should be present" do
    @user.password = " "
    assert_not @user.valid?
  end

  test "password should not be too short" do
    @user.password = "a"*5
    assert_not @user.valid?
  end

  test "authenticated? should return false if there is no digest" do
    assert_not @user.authenticated?('')
  end
end
