// the first javascript file i have written in my life

function get_mail_id(checkbox){
  var idx = checkbox.value.indexOf('-');
  return checkbox.value.substring(0, idx);
}

function get_mail_read(checkbox){
  var idx = checkbox.value.indexOf('-');
  var len = checkbox.value.length;
  return checkbox.value.substring(idx + 1, len);
}

function url_for(checkboxes, user_id, action){
  var len = checkboxes.length;
  var url = '/users/' + user_id + '/mails/' +action + '?';
  for(var i=0;i<len;i++){
    url += ('mail_ids[]=' + get_mail_id(checkboxes[i]));
    if(i != len - 1)
      url += '&';
  }
  return url;
}

function get_all_mails(){
  var checkboxes = [];
  var inputs = $$('input');
  for(var i=0;i<inputs.length;i++){
    if(inputs[i].type == 'checkbox'){
      checkboxes.push(inputs[i]);
    }
  }
  return checkboxes;
}

function get_all_selected_mails(){
  var checkboxes = [];
  var inputs = $$('input');
  for(var i=0;i<inputs.length;i++){
    if(inputs[i].type == 'checkbox' && inputs[i].checked){
      checkboxes.push(inputs[i]);
    }
  }
  return checkboxes;
}

function get_all_read_mails(){
  var checkboxes = [];
  var inputs = $$('input');
  for(var i=0;i<inputs.length;i++){
    if(inputs[i].type == 'checkbox' && get_mail_read(inputs[i]) == 'true'){
      checkboxes.push(inputs[i]);
    }
  }
  return checkboxes;
}

function get_all_unread_mails(){
  var checkboxes = [];
  var inputs = $$('input');
  for(var i=0;i<inputs.length;i++){
    if(inputs[i].type == 'checkbox' && get_mail_read(inputs[i]) == 'false'){
      checkboxes.push(inputs[i]);
    }
  }
  return checkboxes;

}

function uncheck_all_checkboxes(){
  var inputs = $$('input');
  for(var i=0;i<inputs.length;i++){
    if(inputs[i].type == 'checkbox'){
      inputs[i].checked = false;
    }
  }
}

function selection_onchange(){
  var checkboxes = get_all_selected_mails();
  var len = checkboxes.length;
  //TODO: change CSS
}

function select_dropdown_onchange(selector) {
  
  uncheck_all_checkboxes();

  if($F(selector) == 'all'){
    var checkboxes = get_all_mails();
    var len = checkboxes.length;
    for(var i=0;i<len;i++){
      checkboxes[i].checked = true;
    }
  }else if($F(selector) == 'none'){
    var checkboxes = get_all_mails();
    var len = checkboxes.length;
    for(var i=0;i<len;i++)
      checkboxes[i].checked = false;
  }else if($F(selector) == 'read'){
    var checkboxes = get_all_read_mails();
    var len = checkboxes.length;
    for(var i=0;i<len;i++)
      checkboxes[i].checked = true; 
  }else if($F(selector) == 'unread'){
    var checkboxes = get_all_unread_mails();
    var len = checkboxes.length;
    for(var i=0;i<len;i++)
      checkboxes[i].checked = true;
  }
}

function read_mails(user_id) {
  var checkboxes = get_all_selected_mails();
  var url = url_for(checkboxes, user_id, 'read_multiple');
  new Ajax.Request(url, {
    asynchronous: true,
    method: 'put',
    onSuccess: function(transport) {
      var checkboxes = get_all_selected_mails();
      var len = checkboxes.length;
      for(var i=0;i<len;i++){
        var mail = $('mail_' + get_mail_id(checkboxes[i]) + '_title');
        mail.style.fontWeight = '';
        var checkbox = $('select_mail_' + get_mail_id(checkboxes[i]));
        checkbox.value = get_mail_id(checkboxes[i]) + "-true";
      }  
      $('recv_mails_count').innerHTML = transport.responseText;
    }
  });
}

function unread_mails(user_id){
  var checkboxes = get_all_selected_mails();
  var url = url_for(checkboxes, user_id, 'unread_multiple');
  new Ajax.Request(url, {
    asynchronous: true,
    method: 'put',
    onSuccess: function(transport) {
      var checkboxes = get_all_selected_mails();
      var len = checkboxes.length;
      for(var i=0;i<len;i++){
        var mail = $('mail_' + get_mail_id(checkboxes[i]) + '_title');
        mail.style.fontWeight = 'bold';
        var checkbox = $('select_mail_' + get_mail_id(checkboxes[i]));
        checkbox.value = get_mail_id(checkboxes[i]) + "-false";
      }
      $('unread_recv_mails').innerHTML = transport.responseText + " unread";
    }
  });
}

function delete_mails(user_id, type){
  var checkboxes = get_all_selected_mails();
  var url = url_for(checkboxes, user_id, 'destroy_multiple');
  url += ('&' + 'type=' + type);
  new Ajax.Request(url, {
    asynchronous: true,
    method: 'delete',
    onSuccess: function(transport) {
      window.location.href = transport.responseText;
    }
  }); 
}

function after_auto_select(input_field, selected_li){                         
  mail_builder.new_recipient(selected_li.readAttribute('user_id'), 1);
} 
    
function double_check_recipient(){
  mail_builder.check_recipient($('mail_recipients').value);                   
}

MailBuilder = Class.create({
  validate_mail: function(){
  var title = $('mail_title');
  var content = $('mail_content');
  var info = $('mail_info');
  var error = false;

  info.innerHTML = '';

  if(this.recipients.size == 0){
    error = true;
    info.insert('<li style="color: red">you must specify at least one recipient</li>', {position: 'bottom'});
  }
  if(title.value == ''){
    error = true;
    info.insert('<li style="color: red">title cannot be blank</li>', {position: 'bottom'});
  }
  if(content.value == ''){
    error =true;
    info.insert('<li style="color: red">content cannot be blank</li>', {position: 'bottom'});
  }

  if(!error)
    $('mail_recipients').disabled = false;

  return error;
},

  initialize: function(user_id){
    this.user_id = user_id;

    this.recipients = new Hash();
  },

  new_recipient: function(recipient_id, case_id){
    if(this.recipients.get(recipient_id)) return;
    new Ajax.Request('/users/'+this.user_id+'/mails/new_recipient?recipients[]='+recipient_id + '&condition='+case_id, {
      method: 'get',
      onSuccess: function(transport){
        $('recipients_info').innerHTML = transport.responseText + $('recipients_info').innerHTML;
        $('mail_recipients').value=''; 
        var children = $('recipients_info').childElements();
        var length = children.length;
        for(var i=0;i<length;i++){
          this.recipients.set(children[i].readAttribute('recipient_id'), children[i]);
        } 
      }.bind(this)      
    });
  },

  remove_recipient: function(recipient_id){
    var recipient_code = this.recipients.unset(recipient_id);
    recipient_code.remove();
  },
 
  check_recipient: function(recipient_names){
    this.recipients.each(function(pair){
      if (recipient_names.match(pair.value) == null)
        this.recipients.unset(pair.key);
    }.bind(this));
  },

  validate_save: function(){
    if (this.validate_mail()) return;

    var form = $('mail_form');
    var title = $('mail_title').value;
    var content = $('mail_content').value;
    var url = '/users/' + this.user_id;
    url += '/mails?';
    this.recipients.each(function(pair){
      url += "recipients[]=" + pair.key + "&";
    });
    url += "mail[title]=" + title + "&";
    url += "mail[content]=" + content;
    new Ajax.Request(url, {method: 'post'});
  },

});
