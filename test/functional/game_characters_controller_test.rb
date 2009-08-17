require 'test_helper'

class GameCharactersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_characters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_characters" do
    assert_difference('GameCharacters.count') do
      post :create, :game_characters => { }
    end

    assert_redirected_to game_characters_path(assigns(:game_characters))
  end

  test "should show game_characters" do
    get :show, :id => game_characters(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => game_characters(:one).to_param
    assert_response :success
  end

  test "should update game_characters" do
    put :update, :id => game_characters(:one).to_param, :game_characters => { }
    assert_redirected_to game_characters_path(assigns(:game_characters))
  end

  test "should destroy game_characters" do
    assert_difference('GameCharacters.count', -1) do
      delete :destroy, :id => game_characters(:one).to_param
    end

    assert_redirected_to game_characters_path
  end
end
