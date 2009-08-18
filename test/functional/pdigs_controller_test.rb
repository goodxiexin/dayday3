require 'test_helper'

class PdigsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pdigs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pdig" do
    assert_difference('Pdig.count') do
      post :create, :pdig => { }
    end

    assert_redirected_to pdig_path(assigns(:pdig))
  end

  test "should show pdig" do
    get :show, :id => pdigs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => pdigs(:one).to_param
    assert_response :success
  end

  test "should update pdig" do
    put :update, :id => pdigs(:one).to_param, :pdig => { }
    assert_redirected_to pdig_path(assigns(:pdig))
  end

  test "should destroy pdig" do
    assert_difference('Pdig.count', -1) do
      delete :destroy, :id => pdigs(:one).to_param
    end

    assert_redirected_to pdigs_path
  end
end
