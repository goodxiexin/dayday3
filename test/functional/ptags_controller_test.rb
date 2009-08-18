require 'test_helper'

class PtagsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ptags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ptag" do
    assert_difference('Ptag.count') do
      post :create, :ptag => { }
    end

    assert_redirected_to ptag_path(assigns(:ptag))
  end

  test "should show ptag" do
    get :show, :id => ptags(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => ptags(:one).to_param
    assert_response :success
  end

  test "should update ptag" do
    put :update, :id => ptags(:one).to_param, :ptag => { }
    assert_redirected_to ptag_path(assigns(:ptag))
  end

  test "should destroy ptag" do
    assert_difference('Ptag.count', -1) do
      delete :destroy, :id => ptags(:one).to_param
    end

    assert_redirected_to ptags_path
  end
end
