require 'test_helper'

class Admin::PagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_pages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pages" do
    assert_difference('Admin::Pages.count') do
      post :create, :pages => { }
    end

    assert_redirected_to pages_path(assigns(:pages))
  end

  test "should show pages" do
    get :show, :id => admin_pages(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => admin_pages(:one).to_param
    assert_response :success
  end

  test "should update pages" do
    put :update, :id => admin_pages(:one).to_param, :pages => { }
    assert_redirected_to pages_path(assigns(:pages))
  end

  test "should destroy pages" do
    assert_difference('Admin::Pages.count', -1) do
      delete :destroy, :id => admin_pages(:one).to_param
    end

    assert_redirected_to admin_pages_path
  end
end
