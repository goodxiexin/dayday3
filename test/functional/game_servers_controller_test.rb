require 'test_helper'

class GameServersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_servers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_server" do
    assert_difference('GameServer.count') do
      post :create, :game_server => { }
    end

    assert_redirected_to game_server_path(assigns(:game_server))
  end

  test "should show game_server" do
    get :show, :id => game_servers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => game_servers(:one).to_param
    assert_response :success
  end

  test "should update game_server" do
    put :update, :id => game_servers(:one).to_param, :game_server => { }
    assert_redirected_to game_server_path(assigns(:game_server))
  end

  test "should destroy game_server" do
    assert_difference('GameServer.count', -1) do
      delete :destroy, :id => game_servers(:one).to_param
    end

    assert_redirected_to game_servers_path
  end
end
