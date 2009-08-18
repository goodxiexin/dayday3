function enable_big_scomment_form(status_id){
  var big_form = $('big_scomment_'+status_id);
  var small_form = $('small_scomment_'+status_id);
  small_form.hide();
  $('comment_content').value = '';
  big_form.show();
  $('comment_content').focus();
  new Effect.Highlight('big_scomment_'+status_id, {duration:1});
}

function enable_small_scomment_form(status_id){
  var big_form = $('big_scomment_'+status_id);
  var small_form = $('small_scomment_'+status_id);
  big_form.hide();
  small_form.show();
}

function after_create_comment(status_id){
  enable_small_scomment_form(status_id);
  /*var comments = $('scomments_'+status_id).childElements();
  var len = comments.length;
  var comment_id_str = comments[len-1].id;
  var idx = comment_id_str.indexOf('_');
  var comment_id = comment_id_str.substring(idx+1, comment_id_str.length);
  new Effect.Highlight('scomment_'+ comment_id, {duration: 1});*/
}
