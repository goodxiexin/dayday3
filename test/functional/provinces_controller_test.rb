require 'test_helper'

class ProvincesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:provinces)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create province" do
    assert_difference('Province.count') do
      post :create, :province => { }
    end

    assert_redirected_to province_path(assigns(:province))
  end

  test "should show province" do
    get :show, :id => provinces(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => provinces(:one).to_param
    assert_response :success
  end

  test "should update province" do
    put :update, :id => provinces(:one).to_param, :province => { }
    assert_redirected_to province_path(assigns(:province))
  end

  test "should destroy province" do
    assert_difference('Province.count', -1) do
      delete :destroy, :id => provinces(:one).to_param
    end

    assert_redirected_to provinces_path
  end
end
