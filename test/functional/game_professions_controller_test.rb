require 'test_helper'

class GameProfessionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_professions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_profession" do
    assert_difference('GameProfession.count') do
      post :create, :game_profession => { }
    end

    assert_redirected_to game_profession_path(assigns(:game_profession))
  end

  test "should show game_profession" do
    get :show, :id => game_professions(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => game_professions(:one).to_param
    assert_response :success
  end

  test "should update game_profession" do
    put :update, :id => game_professions(:one).to_param, :game_profession => { }
    assert_redirected_to game_profession_path(assigns(:game_profession))
  end

  test "should destroy game_profession" do
    assert_difference('GameProfession.count', -1) do
      delete :destroy, :id => game_professions(:one).to_param
    end

    assert_redirected_to game_professions_path
  end
end
