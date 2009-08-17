require 'test_helper'

class PcommentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pcomments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pcomment" do
    assert_difference('Pcomment.count') do
      post :create, :pcomment => { }
    end

    assert_redirected_to pcomment_path(assigns(:pcomment))
  end

  test "should show pcomment" do
    get :show, :id => pcomments(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => pcomments(:one).to_param
    assert_response :success
  end

  test "should update pcomment" do
    put :update, :id => pcomments(:one).to_param, :pcomment => { }
    assert_redirected_to pcomment_path(assigns(:pcomment))
  end

  test "should destroy pcomment" do
    assert_difference('Pcomment.count', -1) do
      delete :destroy, :id => pcomments(:one).to_param
    end

    assert_redirected_to pcomments_path
  end
end
