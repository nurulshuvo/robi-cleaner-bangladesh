require 'test_helper'

class GhetuControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
