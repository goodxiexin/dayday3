module User::PokesHelper

  def poke_content(poke)
    case poke.content
    when 'hi'
      "#{link_to_user poke.sender} 向你打招呼"
    when 'shake'
      "#{link_to_user poke.sender} 和你握手"
    when 'cuo'
      "#{link_to_user poke.sender} 戳你一下"
    when 'victory'
      "#{link_to_user poke.sender} 向你摆胜利姿势"
    when 'punch'
      "#{link_to_user poke.sender} 打你一拳"
    when 'smile'
      "#{link_to_user poke.sender} 向你微笑"
    when 'se'
      "#{link_to_user poke.sender} 色迷迷的看着你"
    when 'mei'
      "#{link_to_user poke.sender} 向你抛媚眼"
    when 'touch'
      "#{link_to_user poke.sender} 摸着你的头"
    when 'kiss'
      "#{link_to_user poke.sender} 送来飞吻"
    when 'bolt'
      "#{link_to_user poke.sender} 送来一道闪电"
    when 'cai'
      "#{link_to_user poke.sender} 踩你一脚"
    end
  end

end
