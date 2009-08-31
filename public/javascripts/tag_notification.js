 function read_tag_notification(type, type_id, user_id, partial){
  var lis = $('tag_notifications').childElements();
  var length = lis.length;
  var related_items = [];
  
  // get all items with same type and type_id
  for(var i=0;i<length;i++){
    if(lis[i].readAttribute('type') == type && lis[i].readAttribute('type_id') == type_id){
      related_items.push(lis[i]);
    }
  }

  // send ajax request to set these notifications as read
  length = related_items.length;
  params = "";
  for(var i=0;i<length;i++){
    params += "ids[]=" + related_items[i].readAttribute('notification_id') + "&";
  }
  new Ajax.Request('/users/'+user_id+'/'+'tag_notifications/read_multiple?' + params, {
    method: 'post',
    onSuccess: function(transport){
      for(var i=0;i<length;i++){
        if(!partial){
          var children = related_items[i].childElements();
          var size = children.length;
          children[size-1].style.fontWeight = '';
        }else{
          related_items[i].remove();
        }
      }
    }
  });
}

