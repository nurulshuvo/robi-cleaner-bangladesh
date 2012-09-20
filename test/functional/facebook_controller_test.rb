require 'test_helper'

class FacebookControllerTest < ActionController::TestCase
  test "should get landing_page" do
    get :landing_page
    assert_response :success
  end

  test "should get home_page" do
    get :home_page
    assert_response :success
  end

end
