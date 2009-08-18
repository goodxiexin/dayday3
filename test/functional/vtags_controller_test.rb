require 'test_helper'

class VtagsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vtags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vtag" do
    assert_difference('Vtag.count') do
      post :create, :vtag => { }
    end

    assert_redirected_to vtag_path(assigns(:vtag))
  end

  test "should show vtag" do
    get :show, :id => vtags(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => vtags(:one).to_param
    assert_response :success
  end

  test "should update vtag" do
    put :update, :id => vtags(:one).to_param, :vtag => { }
    assert_redirected_to vtag_path(assigns(:vtag))
  end

  test "should destroy vtag" do
    assert_difference('Vtag.count', -1) do
      delete :destroy, :id => vtags(:one).to_param
    end

    assert_redirected_to vtags_path
  end
end
