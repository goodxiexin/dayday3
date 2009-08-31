module User::PrivacySettingHelper

  def show_personal_setting(setting)
    level = setting.personal
    if level == 0 # all
      "All can view"
    elsif level == 1 # friends
      "Friends can view"
    elsif level == 2 # same game
      "People playing same game can view"
    end
  end

  def personal_select_tag(setting)
    select_tag "setting[personal]", options_for_select([['all', 0], ['friends', 1], ['people playing same game', 2]], setting.personal), :style => "width: 150px"
  end

  def show_friend_setting(setting)
    level = setting.friend
    if level == 0 # all
      "All can send you request"
    elsif level == 1
      "People playing same agme can send you request"
    end 
  end

  def friend_select_tag(setting)
    select_tag "setting[friend]", options_for_select([['all', 0], ['people playing same game', 1]], setting.friend), :style => "width: 150px" 
  end

  def show_search_setting(setting)
    if setting.search
      "People can get your info through search engine"
    else
      "People cannot get your info through search engine"
    end
  end

end
