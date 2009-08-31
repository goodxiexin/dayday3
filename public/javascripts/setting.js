function show_setting_menus(link, user_id){
  var menus = $('setting_menu');

  if(menus){
    menus.show();
    return;
  }
  // construct html element
  // html code looks like
  var html = "";
  html += '<ul><li><img src="/images/privacy.gif"/><a href="/users/' + user_id + '/privacy_setting"> privacy settings </a></li>';
  html += '<li><img src="/images/account.gif"/><a href="/users/' + user_id + '/password/edit"> account settings </a></li>';
  html += '<li><img src="/images/application.gif"/><a href="/users/' + user_id + '/application_setting"> application settings </a></li></ul>';
  var menu_div = new Element('div', {class: 'setting-menu', id: 'setting_menu'});
  menu_div.innerHTML = html;
 
  var left = link.positionedOffset().left;
  var top = link.positionedOffset().top + link.getHeight() - 2;
  
  menu_div.setStyle({
    position: 'absolute',
    left: left + 'px',
    top: top + 'px',
    height: '100px'
  });

  document.body.appendChild(menu_div);
  menu_div.show();

  menu_div.observe('mouseout', function(event){
    if($(event.target) == $('setting_menu') && !$(event.relatedTarget).childOf($('setting_menu'))){
      $('setting_menu').hide();
    }
  });


}
