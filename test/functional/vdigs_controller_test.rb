require 'test_helper'

class VdigsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vdigs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vdig" do
    assert_difference('Vdig.count') do
      post :create, :vdig => { }
    end

    assert_redirected_to vdig_path(assigns(:vdig))
  end

  test "should show vdig" do
    get :show, :id => vdigs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => vdigs(:one).to_param
    assert_response :success
  end

  test "should update vdig" do
    put :update, :id => vdigs(:one).to_param, :vdig => { }
    assert_redirected_to vdig_path(assigns(:vdig))
  end

  test "should destroy vdig" do
    assert_difference('Vdig.count', -1) do
      delete :destroy, :id => vdigs(:one).to_param
    end

    assert_redirected_to vdigs_path
  end
end
