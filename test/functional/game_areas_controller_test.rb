require 'test_helper'

class GameAreasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_areas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_area" do
    assert_difference('GameArea.count') do
      post :create, :game_area => { }
    end

    assert_redirected_to game_area_path(assigns(:game_area))
  end

  test "should show game_area" do
    get :show, :id => game_areas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => game_areas(:one).to_param
    assert_response :success
  end

  test "should update game_area" do
    put :update, :id => game_areas(:one).to_param, :game_area => { }
    assert_redirected_to game_area_path(assigns(:game_area))
  end

  test "should destroy game_area" do
    assert_difference('GameArea.count', -1) do
      delete :destroy, :id => game_areas(:one).to_param
    end

    assert_redirected_to game_areas_path
  end
end
