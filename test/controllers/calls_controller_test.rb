require 'test_helper'

class CallsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    sign_in User.first

    # @call = calls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    # assert_not_nil assigns(:calls)
  end

#  test "should show call" do
#    get :show, id: @call
#    assert_response :success
#  end
#
#  test "should get edit" do
#    get :edit, id: @call
#    assert_response :success
#  end
#
#  test "should update call" do
#    patch :update, id: @call, call: {  }
#    assert_redirected_to call_path(assigns(:call))
#  end
#
#  test "should destroy call" do
#    assert_difference('Call.count', -1) do
#      delete :destroy, id: @call
#    end
#
#    assert_redirected_to calls_path
#  end
end
