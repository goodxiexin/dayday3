require 'test_helper'

class BcommentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bcomments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bcomment" do
    assert_difference('Bcomment.count') do
      post :create, :bcomment => { }
    end

    assert_redirected_to bcomment_path(assigns(:bcomment))
  end

  test "should show bcomment" do
    get :show, :id => bcomments(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => bcomments(:one).to_param
    assert_response :success
  end

  test "should update bcomment" do
    put :update, :id => bcomments(:one).to_param, :bcomment => { }
    assert_redirected_to bcomment_path(assigns(:bcomment))
  end

  test "should destroy bcomment" do
    assert_difference('Bcomment.count', -1) do
      delete :destroy, :id => bcomments(:one).to_param
    end

    assert_redirected_to bcomments_path
  end
end
