require 'test_helper'

class VcommentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vcomments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vcomment" do
    assert_difference('Vcomment.count') do
      post :create, :vcomment => { }
    end

    assert_redirected_to vcomment_path(assigns(:vcomment))
  end

  test "should show vcomment" do
    get :show, :id => vcomments(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => vcomments(:one).to_param
    assert_response :success
  end

  test "should update vcomment" do
    put :update, :id => vcomments(:one).to_param, :vcomment => { }
    assert_redirected_to vcomment_path(assigns(:vcomment))
  end

  test "should destroy vcomment" do
    assert_difference('Vcomment.count', -1) do
      delete :destroy, :id => vcomments(:one).to_param
    end

    assert_redirected_to vcomments_path
  end
end
