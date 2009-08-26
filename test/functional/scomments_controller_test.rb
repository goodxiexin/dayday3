require 'test_helper'

class ScommentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scomments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create scomment" do
    assert_difference('Scomment.count') do
      post :create, :scomment => { }
    end

    assert_redirected_to scomment_path(assigns(:scomment))
  end

  test "should show scomment" do
    get :show, :id => scomments(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => scomments(:one).to_param
    assert_response :success
  end

  test "should update scomment" do
    put :update, :id => scomments(:one).to_param, :scomment => { }
    assert_redirected_to scomment_path(assigns(:scomment))
  end

  test "should destroy scomment" do
    assert_difference('Scomment.count', -1) do
      delete :destroy, :id => scomments(:one).to_param
    end

    assert_redirected_to scomments_path
  end
end
