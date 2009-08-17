require 'test_helper'

class MailsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mail" do
    assert_difference('Mail.count') do
      post :create, :mail => { }
    end

    assert_redirected_to mail_path(assigns(:mail))
  end

  test "should show mail" do
    get :show, :id => mails(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => mails(:one).to_param
    assert_response :success
  end

  test "should update mail" do
    put :update, :id => mails(:one).to_param, :mail => { }
    assert_redirected_to mail_path(assigns(:mail))
  end

  test "should destroy mail" do
    assert_difference('Mail.count', -1) do
      delete :destroy, :id => mails(:one).to_param
    end

    assert_redirected_to mails_path
  end
end
