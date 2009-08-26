function unfold_bcomments(blog_id){
  var fold = $('fold_bcomments_'+blog_id);
  var unfold = $('unfold_bcomments_'+blog_id);
  var bcomments_div = $("bcomments_" + blog_id);
  var bcomments_form_div = $("bcomments_form_" + blog_id);

  if(bcomments_div.childElements().size() != 0){
    bcomments_div.show();
    bcomments_form_div.show();
    unfold.hide();
    fold.show();
    return;
  }

  new Ajax.Updater("bcomments_" + blog_id, '/blogs/'+blog_id+'/comments', {
    method: 'get',
    onComplete: function(transport){
      unfold.hide();
      fold.show();
      bcomments_form_div.show();
    }
  });
}

function fold_bcomments(blog_id){
  var fold = $('fold_bcomments_'+blog_id);
  var unfold = $('unfold_bcomments_'+blog_id);
  var bcomments_div = $('bcomments_'+blog_id);
  var bcomments_form_div = $('bcomments_form_'+blog_id);

  bcomments_form_div.hide();
  bcomments_div.hide();
  fold.hide();
  unfold.show();
}


function unfold_scomments(status_id){
  var fold = $('fold_scomments_'+status_id);
  var unfold = $('unfold_scomments_'+status_id);
  var scomments_div = $("scomments_" + status_id);
  var scomments_form_div = $("scomments_form_" + status_id);
 
  if(scomments_div.childElements().size() != 0){
    scomments_div.show();
    scomments_form_div.show();
    unfold.hide();
    fold.show();
    return;
  }

  new Ajax.Updater("scomments_" + status_id, '/statuses/'+status_id+'/comments', {
    method: 'get',
    onComplete: function(transport){
      unfold.hide();
      fold.show();
      scomments_form_div.show();
    }
  });
}

function fold_scomments(status_id){
  var fold = $('fold_scomments_'+status_id);
  var unfold = $('unfold_scomments_'+status_id);
  var scomments_div = $('scomments_'+status_id);
  var scomments_form_div = $('scomments_form_'+status_id);  
  
  scomments_form_div.hide();
  scomments_div.hide();
  fold.hide();
  unfold.show();
}


function unfold_vcomments(video_id){
  var fold = $('fold_vcomments_'+video_id);
  var unfold = $('unfold_vcomments_'+video_id);
  var vcomments_div = $("vcomments_" + video_id);
  var vcomments_form_div = $("vcomments_form_" + video_id);
 
  if(vcomments_div.childElements().size() != 0){
    vcomments_div.show();
    vcomments_form_div.show();
    unfold.hide();
    fold.show();
    return;
  }

  new Ajax.Updater("vcomments_" + video_id, '/videos/'+video_id+'/comments', {
    method: 'get',
    onComplete: function(transport){
      unfold.hide();
      fold.show();
      vcomments_form_div.show();
    }
  });
}

function fold_vcomments(video_id){
  var fold = $('fold_vcomments_'+video_id);
  var unfold = $('unfold_vcomments_'+video_id);
  var vcomments_div = $('vcomments_'+video_id);
  var vcomments_form_div = $('vcomments_form_'+video_id);  
  
  vcomments_form_div.hide();
  vcomments_div.hide();
  fold.hide();
  unfold.show();
}

function get_all_feeds(user_id){
  var url = '/users/' + user_id + '/resource_feeds/get?idx=0';
  $('feeds').innerHTML = '';
  $('more_feeds').innerHTML = '';
  new Ajax.Request(url, {method: 'get'});
}

function get_status_feeds(user_id){
  var url = '/users/' + user_id + '/status_feeds/get?idx=0';
  $('feeds').innerHTML = '';
  $('more_feeds').innerHTML = '';
  new Ajax.Request(url, {method: 'get'});
}

function get_blog_feeds(user_id){
  var url = '/users/' + user_id + '/blog_feeds/get?idx=0';
  $('feeds').innerHTML = '';
  $('more_feeds').innerHTML = '';
  new Ajax.Request(url, {method: 'get'});
} 

function get_video_feeds(user_id){
  var url = '/users/' + user_id + '/video_feeds/get?idx=0';
  $('feeds').innerHTML = '';
  $('more_feeds').innerHTML = '';
  new Ajax.Request(url, {method: 'get'});
} 

function get_album_feeds(user_id){
  var url = '/users/' + user_id + '/album_feeds/get?idx=0';
  $('feeds').innerHTML = '';
  $('more_feeds').innerHTML = '';
  new Ajax.Request(url, {method: 'get'});
} 

function get_feeds_in_game(user_id, game_id){
  var url = '/users/' + user_id + '/resource_feeds/get?idx=0&game_id='+game_id;
  $('feeds').innerHTML = '';
  $('more_feeds').innerHTML = '';
  new Ajax.Request(url, {method: 'get'});
}

