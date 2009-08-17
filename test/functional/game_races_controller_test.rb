require 'test_helper'

class GameRacesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_races)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_races" do
    assert_difference('GameRaces.count') do
      post :create, :game_races => { }
    end

    assert_redirected_to game_races_path(assigns(:game_races))
  end

  test "should show game_races" do
    get :show, :id => game_races(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => game_races(:one).to_param
    assert_response :success
  end

  test "should update game_races" do
    put :update, :id => game_races(:one).to_param, :game_races => { }
    assert_redirected_to game_races_path(assigns(:game_races))
  end

  test "should destroy game_races" do
    assert_difference('GameRaces.count', -1) do
      delete :destroy, :id => game_races(:one).to_param
    end

    assert_redirected_to game_races_path
  end
end
