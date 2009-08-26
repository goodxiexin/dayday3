
function show_qq_requirement(){
  $('qq_info').innerHTML = '<span style="color:grey">input your real qq</span>';
}

function validate_qq(qq){
  var info = $('qq_info');
 
  if(qq == '')
    return true; //qq is not mandatory  

  if(qq.length < 6 || qq.length > 11){
    info.innerHTML = '<span style="color: red">this qq number is not valid</span>';
    return false;
  }

  if(parseInt(qq)){
    info.innerHTML = '<span style="color: green">valid</span>';
    return true;
  }else{
    info.innerHTML = '<span style="color: red">only digits are allowed here</span>';
    return false;
  }
}

function show_webiste_requirement(){
  $('website_info').innerHTML = '<span style="color:grey">input your personal website</span>';
}

function validate_website(website){
  var info = $('website_info');
  info.innerHTML = '<span style="color: green">valid</span>';
  return true;
}

function show_mobile_requirement(){
  $('mobile_info').innerHTML = '<span style="color:grey">input your mobile number</span>';
}

function validate_mobile(mobile){
  var info = $('mobile_info');

  if(mobile == '')   
    return true; //qq is not mandatory  

  if(mobile.length != 11){
    info.innerHTML = '<span style="color: red">this mobile phone number is not valid</span>';
    return false;
  }
  
  if(parseInt(mobile)){
    info.innerHTML = '<span style="color: green">valid</span>';
    return true;
  }else{
    info.innerHTML = '<span style="color: red">only digits are allowed here</span>';
    return false;
  }
}

function validate_contact_info(){
  var error = false;
  var qq = $('user_qq').value;
  var mobile = $('user_mobile').value;
  var website = $('user_website').value;

  if(!validate_qq(qq)) error = true;
  if(!validate_mobile(mobile)) error = true;
  if(!validate_website(website)) error = true; 
  
  return error;
}

function update_contact_info(user_id){
  if(validate_contact_info()) return;
  
  var form = $('contact_form');
  var url = '/users/' + user_id + '/contact_info?' + form.serialize();

  new Ajax.Request(url, {method: 'put'});
}

function validate_basic_info(){
  var error = false;
  var login = $('user_login').value;
  
  if(!validate_login(login)) error = true;
  
  return error;
}

function update_basic_info(user_id){
  if(validate_basic_info()) return;
  
  var form = $('basic_form');
  var url = '/users/' + user_id + '/basic_info?' + form.serialize();
  
  new Ajax.Request(url, {method: 'put'}); 
}

function show_login_requirement(){
  $('login_info').setStyle({color: 'grey'}); 
  $('login_info').innerHTML = 'only digits, letters and underscore are allowed, range 4..16';
}

function validate_login(name){
  var info = $('login_info');  

  // check presence
  if(name == ''){
    info.innerHTML = '<span style="color: red">login cannot be blank</span>';
    return false;
  }

  // check length
  if(name.length < 6){
    info.innerHTML = '<span style="color: red">too short, at least 6 characters</span>';
    return false;
  }
  if(name.length > 16){
    info.innerHTML = '<span style="color: red">too long, at most 16 characters</span>';
    return false;
  }

  // check pattern
  first = name[0];
  if((first >= 'a' && first <= 'z') || (first >= 'A' && first <= 'Z')){
    if(name.match(/[A-Za-z0-9\_]+/)){
      info.innerHTML = '<span style="color: green">valid</span>';
      return true;
    }else{
      info.innerHTML = '<span style="color: red">only digits, letters and underscore are allowed</span>';
      return false;
    }
  }else{
    info.innerHTML = '<span style="color: red">must start with A-Z or a-z</span>';
    return false;
  }
}

function show_email_requirement(){
  $('email_info').setStyle({color: 'grey'});
  $('email_info').innerHTML = 'please input valid email box'
}

function validate_email(email){
  var info = $('email_info');

  // check presence
  if(email == ''){
    info.innerHTML = '<span style="color: red">email cannot be blank</span>';
    return false;
  }

  // check length
  if(email.length < 6){
    info.innerHTML = '<span style="color: red">too short, at least 6 characters</span>';
    return false;
  }
  if(email.length > 100){
    info.innerHTML = '<span style="color: red">too long, at most 100 characters</span>';
    return false;
  }

  // check pattern
  if(email.match(/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/)){
    // send ajax request to check uniqueness
    new Ajax.Request('/validator/validates_email_uniqueness?email='+email, {
      method: 'get',
      onSuccess: function(transport){
        var info = $('email_info');
        if(transport.responseText == 'yes'){
          info.innerHTML = '<span style="color: green">valid</span>';
        }else{
          info.innerHTML = '<span style="color: red">this email has already been occupied</span>';
        }
      }
    });
    return true;
  }else{
    info.innerHTML = '<span style="color: red">invalid email format</span>';
    return false;
  }
}

function show_password_requirement(){
  $('password_info').setStyle({color: 'grey'});
  $('password_info').innerHTML = 'password consists of 6-20 characters'
}

function validate_password(password){
  var info = $('password_info')

  var strongReg = new RegExp("^(?=.{8,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*\\W).*$", "g");
  var mediumReg = new RegExp("^(?=.{7,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$", "g");

  // check length
  if(password.length < 6){
    info.innerHTML = '<span style="color: red">too short, at least 6 characters</span>';
    return false;
  }
  if(password.length > 20){
    info.innerHTML = '<span style="color: red">too long, at most 20 characters</span>';
    return false;
  }

  // check strength
  if(password.match(strongReg)){
    info.innerHTML = '<span style="color: green">Valid: Strong Strength!</span>';
    return true;
  }else if(password.match(mediumReg)){
    info.innerHTML = '<span style="color: orange">Valid: Medium Strength!</span>';
    return true;
  }else{
    info.innerHTML = '<span style="color: red"> Valid: Weak Strength!</span>';
    return true;
  }
}

function show_password_confirm_requirement(){
  $('password_confirmation_info').setStyle({color: 'grey'});
  $('password_confirmation_info').innerHTML = 'confirm your password'
}

function validate_password_confirmation(password_confirmation){
  var info = $('password_confirmation_info');
  var password = $('user_password').value;

  if(password == ''){
    info.innerHTML = '<span style="color: red"> password cannot be blank </span>';
    return false;
  }

  if(password == password_confirmation){
    info.innerHTML = '<span style="color: green">Valid</span>';
    return true;
  }else{
    info.innerHTML = '<span style="color: red">Two passwords are not consistent</span>';
    return false;
  }
}

function validate_register_info(){
  var error = false;
  var login = $('user_login').value;
  var email = $('user_email').value;
  var password = $('user_password').value;
  var password_confirmation = $('user_password_confirmation').value;

  if(!validate_login(login)) error = true;
  if(!validate_email(email)) error = true;
  if(!validate_password(password)) error = true;
  if(!validate_password_confirmation(password_confirmation)) error = true;

  var form = $('register_form');
  var cs = $('characters').childElements();
  var length = cs.length;
  if(length == 0){
    $('character_info').innerHTML = '<span style="color:red">You must specify at least one game character</span>'
    error = true;
  }

  return error;
}

function validate_game_id(game_id){
  var info = $('game_id_info');

  if(game_id != '---'){
    info.innerHTML = '<span style="color: green"> valid </span>';
    return true;
  }else{
    info.innerHTML = '<span style="color: red"> game cannot be blank </span>';
    return false;
  }
}

function game_onchange(game_id){
  if(game_id == '---'){
    $('details').innerHTML = '';
  }else{
<<<<<<< HEAD:public/javascripts/validator.js
    new Ajax.Updater('details', '/games/' + game_id + '?show=1', {method: 'get'});
  }
}

function game_onchange_event(game_id){
  if(game_id == '---'){
    $('game_details').innerHTML = '';
  }else{
    new Ajax.Updater('details', '/register/game_details?game_id=' + game_id, {method: 'get'});
  }
}

function show_name_requirement(){
  var info = $('name_info');
  info.innerHTML = '<span style="color: grey"> Input your character name </span>';
}

function validate_name(name){
  var info = $('name_info');
  
  if(name == ''){
    info.innerHTML = '<span style="color: red"> name cannot be blank </span>';
    return false;
  }else{
    info.innerHTML = '<span style="color: green"> valid </span>'; 
    return true;
  }
}

function show_level_requirement(){
  var info = $('level_info');
  info.innerHTML = '<span style="color: grey"> Input your character level </span>';
}

function validate_level(level){
  var info = $('level_info');
  
  if(level == ''){
    info.innerHTML = '<span style="color: red"> level cannot be blank </span>';
    return false;
  }else{
    if(parseInt(level)){
      info.innerHTML = '<span style="color: green"> valid </span>';
      return true;
    }else{
      info.innerHTML = '<span style="color: red"> level should be an integer </span>';
      return false;
    }
  }
}

function validate_server_id(server_id){
  var info = $('server_id_info');

  if(server_id != '---'){
    info.innerHTML = '<span style="color: green"> valid </span>';
    return true;
  }else{
    info.innerHTML = '<span style="color: red"> server cannot be blank </span>';
    return false;
  }
}

function validate_area_id(area_id){
  var info = $('area_id_info');

  if(area_id != '---'){
    info.innerHTML = '<span style="color: green"> valid </span>';
    return true;
  }else{
    info.innerHTML = '<span style="color: red"> area cannot be blank </span>';
    return false;
  }
}

function area_onchange(area_id,showValue){
  if(area_id == '---'){
    $('servers').innerHTML = '<label style="width:125px;float:left">Game Server:</label><select id="server_id" name="server_id"><option value="---">---</option></select>';
  }else{
    new Ajax.Updater('servers', '/register/area_details?area_id=' + area_id, {method: 'get'});
  }
}

function validate_race_id(race_id){
  var info = $('race_id_info');

  if(race_id != '---'){
    info.innerHTML = '<span style="color: green"> valid </span>';
    return true;
  }else{
    info.innerHTML = '<span style="color: red"> race cannot be blank </span>';
    return false;
  }
}

function validate_profession_id(profession_id){
  var info = $('profession_id_info');

  if(profession_id != '---'){
    info.innerHTML = '<span style="color: green"> valid </span>';
    return true;
  }else{
    info.innerHTML = '<span style="color: red"> profession cannot be blank </span>';
    return false;
  }
}

var nr=0;

function validate_game_character(){
  // check all parameters
  var error = false;
  var game_id = $('character_game_id').value;
  var name = $('character_name').value;
  var level = $('character_level').value;

  if(!validate_name(name)) error = true;
  if(!validate_level(level)) error = true;
  if(!validate_game_id(game_id)) error = true;

  if(game_id == '---')
    return true;

  var server_id = $('character_server_id').value;
  var race_id = $('character_race_id').value;
  var profession_id = $('character_profession_id').value;
  var area_id = null;

  if(!validate_server_id(server_id)) error = true;
  if(!validate_race_id(race_id)) error = true;
  if(!validate_profession_id(profession_id)) error = true;
  if($('character_area_id') != null){
    area_id = $('character_area_id').value;
    if(!validate_area_id(area_id)) error = true;
  }
  
  return error;
}

function construct_game_character_element(){
  var game_id = $('character_game_id').value;
  var name = $('character_name').value;
  var level = $('character_level').value;
  var server_id = $('character_server_id').value;
  var race_id = $('character_race_id').value;
  var profession_id = $('character_profession_id').value;
  var area_id = null;
  
  // construct a character element that will show on registration page
  // html code looks like:
  // <li character_attributes> character_name <a href='#' onClick='edit_character'>edit</a> <a href='#' onClick='delete_character'>edit</a></li>
  var li = new Element('li', {id: 'character'+nr, game_id: game_id, name: name, level: level, server_id: server_id, race_id: race_id, profession_id: profession_id});
  if($('character_area_id') != null){
    area_id = $('character_area_id').value;
    li.writeAttribute({area_id: area_id});
  }

  // construct label
  var label = new Element('label').update(name);
  label.setStyle({
    float:'left',
    width: '125px'
  });

  // construct url and edit link
  var parameters = 'id='+nr+'&' +$('character_form').serialize();
  var url = '/register/edit_character?' + parameters;
  var edit_link = new Element('a', { href: url, rel: 'facebox'}).update('edit');
  
  // construct seperator
  var seperator = new Element('label').update(' | ')

  // construct delete link and its event
  var delete_link = new Element('a', { href: '#'}).update('delete');
  delete_link.observe('click', function(event){
    if(confirm('are you sure?'))
      this.parentNode.remove();
  });

  // append elements to li
  li.appendChild(label);
  li.appendChild(edit_link);
  li.appendChild(seperator);
  li.appendChild(delete_link);
  nr++;

  return li;
}


function add_character(){
  if(validate_game_character()) return;

  $('characters').insert(construct_game_character_element());
  
  // close current facebox
  facebox.watchClickEvents();
  facebox.close(); 
}

function add_user_character(user_id){
  if(validate_game_character()) return;
  
  var form = $('character_form');
  var url = '/users/' + user_id + '/characters?' + form.serialize();

  new Ajax.Request(url, {method: 'post'});
}

function update_character(id){
  if(validate_game_character()) return;

  $('character'+id).replace(construct_game_character_element());

  // close current facebox
  facebox.watchClickEvents();
  facebox.close();

}

function update_user_character(user_id, id){
  if(validate_game_character()) return;
  
  var form = $('character_form');
  var url = '/users/' + user_id + '/characters/' + id + '?' + form.serialize();
  
  new Ajax.Request(url, {method: 'put'});
}

function validate_and_request(){
  if(validate_register_info()) return;

  // check if user has input at least one game character
  var form = $('register_form');
  var cs = $('characters').childElements();
  var length = cs.length;

  // construct url and parameter
  var parameters = '';
  for(var i=0;i<length;i++){
    var game_id = cs[i].readAttribute('game_id');
    var name = cs[i].readAttribute('name');
    var level = cs[i].readAttribute('level');
    var area_id = cs[i].readAttribute('area_id');
    var server_id = cs[i].readAttribute('server_id');
    var race_id = cs[i].readAttribute('race_id');
    var profession_id = cs[i].readAttribute('profession_id');
    parameters += 'cs[][game_id]='+game_id+'&cs[][name]='+name+'&cs[][level]='+level+'&cs[][server_id]='+server_id+'&cs[][race_id]='+race_id+'&cs[][profession_id]='+profession_id;
    if(area_id != null)
      parameters += '&cs[][area_id]=' + area_id;
    parameters += '&';
  }
  parameters += form.serialize();
  url = '/users?' + parameters;
  
  // send request to server
  new Ajax.Request(url, {method: 'post'});
}
