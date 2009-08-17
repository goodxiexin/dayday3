require 'test_helper'

class BdigsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bdigs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bdig" do
    assert_difference('Bdig.count') do
      post :create, :bdig => { }
    end

    assert_redirected_to bdig_path(assigns(:bdig))
  end

  test "should show bdig" do
    get :show, :id => bdigs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => bdigs(:one).to_param
    assert_response :success
  end

  test "should update bdig" do
    put :update, :id => bdigs(:one).to_param, :bdig => { }
    assert_redirected_to bdig_path(assigns(:bdig))
  end

  test "should destroy bdig" do
    assert_difference('Bdig.count', -1) do
      delete :destroy, :id => bdigs(:one).to_param
    end

    assert_redirected_to bdigs_path
  end
end
