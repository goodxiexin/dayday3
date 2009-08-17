require 'test_helper'

class WallMessagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wall_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wall_message" do
    assert_difference('WallMessage.count') do
      post :create, :wall_message => { }
    end

    assert_redirected_to wall_message_path(assigns(:wall_message))
  end

  test "should show wall_message" do
    get :show, :id => wall_messages(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => wall_messages(:one).to_param
    assert_response :success
  end

  test "should update wall_message" do
    put :update, :id => wall_messages(:one).to_param, :wall_message => { }
    assert_redirected_to wall_message_path(assigns(:wall_message))
  end

  test "should destroy wall_message" do
    assert_difference('WallMessage.count', -1) do
      delete :destroy, :id => wall_messages(:one).to_param
    end

    assert_redirected_to wall_messages_path
  end
end
