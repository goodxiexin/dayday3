require 'test_helper'

class BtagsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:btags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create btag" do
    assert_difference('Btag.count') do
      post :create, :btag => { }
    end

    assert_redirected_to btag_path(assigns(:btag))
  end

  test "should show btag" do
    get :show, :id => btags(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => btags(:one).to_param
    assert_response :success
  end

  test "should update btag" do
    put :update, :id => btags(:one).to_param, :btag => { }
    assert_redirected_to btag_path(assigns(:btag))
  end

  test "should destroy btag" do
    assert_difference('Btag.count', -1) do
      delete :destroy, :id => btags(:one).to_param
    end

    assert_redirected_to btags_path
  end
end
