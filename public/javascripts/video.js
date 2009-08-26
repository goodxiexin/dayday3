VideoBuilder = Class.create({

  initialize: function(user_id, video_id){
    // save user id and video id
    this.user_id = user_id;
    this.video_id = video_id;
  
    // save tag input field and set its initial text
    this.tag_input = $('video_tags');
    this.tag_input.value = 'please tag your friend here';
    
    // add on focus event to tag input
    this.tag_input.observe('focus', function(event){
      this.value = '';
    });

    // add on blur event to tag input
    this.tag_input.observe('blur', function(event){
      this.value = 'please tag your friends here';
    });

    // input form
    this.form = $('video_input'); 

    // save btags div which displays all current btags
    this.vtags_div = $('vtags');

    // fold, unfold handler
    this.unfold = $('unfold');
    
    // we maintain a hash of blog tags
    this.vtags = new Hash();
    var vtags = this.vtags_div.childElements();
    for(var i=0;i<vtags.length;i++){
      this.vtags.set(vtags[i].readAttribute('tagged_user_id'), vtags[i]);
    }
  },

  /*
   * hide friends list
   */
  hide_friends: function(){
    this.popup.hide();
    this.unfold.update('unfold');
    this.unfold.observe('click', function(){
      this.show_friends(); 
    }.bind(this));
  },

  /*
   * show friends
   */
  show_friends: function(){
    if(this.popup){
      this.popup.show();
    }else{
      // create popup frame with the following html code:
      // <div>
      //   <div> select friends: <select> select game here </select></div>
      //   <div> friend list </div>
      //   <button> confirm </button>
      // </div>
      this.popup = new Element('div');
      this.game_category = new Element('div');
      this.label = new Element('label').update('select friends: ');
      this.selector = new Element('select');
      this.friends_list = new Element('div');
      this.confirm_button = new Element('button').update('confirm');
      this.game_category.appendChild(this.label);
      this.game_category.appendChild(this.selector);
      this.popup.appendChild(this.game_category);
      this.popup.appendChild(this.friends_list);
      this.popup.appendChild(this.confirm_button);
    
      // add click event to confirm button
      this.set_button_event();
    
      // send ajax request to retrieve all the games
      this.get_games();
    
      // send ajax request to retrieve all friends
      this.get_friends('all'); 
    
      // add popup element to document
      document.body.appendChild(this.popup);
      this.popup.hide();
 
      // set friend list style
      this.friends_list.setStyle({
        width: '350px',
        height: '150px',
        overflow: 'auto'
      });

      // set popup frame position
      this.popup.setStyle({
        position: 'absolute',
        left: (this.unfold.positionedOffset().left - 350) + 'px',
        top: this.unfold.positionedOffset().top + 'px'
      });

      this.popup.show();
    }

    this.unfold.update('fold');
    this.unfold.observe('click', function(){
      this.hide_friends();
    }.bind(this));
  }, 

  /*
   * return an array of tagged users id
   */
  get_tagged_users: function(){
    var inputs = $$('input');
    var length = inputs.length;
    var tagged_users = [];
    for(var i = 0; i < length; i++){
      if(inputs[i].type == 'checkbox' && inputs[i].checked && !this.vtags.get(inputs[i].value)){
        tagged_users.push(inputs[i].value);
      }
    }
    return tagged_users;
  },

  /*
   * add click listener for confirm button
   */
  set_button_event: function(){
    this.confirm_button.observe('click', function(event){
      var tagged_users = this.get_tagged_users();

      // if no one is selected,
      // remove popup frame and return
      if(tagged_users.length == 0){
        this.hide_friends();
        return;
      }

      // construct parameters and url
      var url = '/user/videos/new_tag?';
      for(var i=0;i<tagged_users.length;i++){
        url += "tagged_users[]=" + tagged_users[i] + "&";
      }

      // send ajax request to retreive user info
      // note that at this time, the tags are not stored in database yet
      new Ajax.Request(url, {
        method: 'get',
        onSuccess: function(transport){
          this.vtags_div.innerHTML = transport.responseText + this.vtags_div.innerHTML;
          this.hide_friends();
          var children = this.vtags_div.childElements();
          var length = children.length;
          for(var i=0;i<length;i++){
            this.vtags.set(children[i].readAttribute('tagged_user_id'), children[i]);
          }
        }.bind(this)
      });
    }.bind(this));
  },

  /*
   * return relevant games
   */
  get_games: function(){
    // send ajax request to retrieve all the games
    new Ajax.Request('/user/blogs/games_list', {
      method: 'get',
      onSuccess: function(transport){
        // fill in selecter with retreived game options
        this.selector.innerHTML = transport.responseText;

        // add on change listener to selector
        this.selector.observe('change', function(){
          // get friends within the same game
          this.get_friends($F(this.selector)); 
        }.bind(this));
      }.bind(this)
    });
  },

  /*
   * return friends within same game
   */
  get_friends: function(game_id){
    new Ajax.Request('/user/blogs/friends_list?game_id=' + game_id, {
      method: 'get',
      onSuccess: function(transport){
        this.friends_list.innerHTML = transport.responseText;
      }.bind(this)
    });
  }, 

  /*
   * new tag
   * pay attention that this tag is not stored in database until you click 'save' or 'save as draft'
   */
  new_tag: function(tagged_user_id){
    // if this user is already tagged, skip it
    if(this.vtags.get(tagged_user_id)) return;

    // send ajax request to retrieve user information(icon, name ... so on)
    new Ajax.Request('/user/videos/new_tag?tagged_users[]=' + tagged_user_id, {
      method: 'get',
      onSuccess: function(transport){
        this.vtags_div.innerHTML = transport.responseText + this.vtags_div.innerHTML;
        this.tag_input.value = '';
        var children = this.vtags_div.childElements();
        var length = children.length;
        for(var i=0;i<length;i++){
          this.vtags.set(children[i].readAttribute('tagged_user_id'), children[i]);
        }
      }.bind(this)
    }); 
  },

  /*
   * remove tag
   */
  remove_tag: function(tagged_user_id){
    var vtag = this.vtags.unset(tagged_user_id);
    if(!vtag) return;
    // if it's not a new record, it means it stores in database,
    // then do an ajax request to remove it from database
    if(vtag.readAttribute('new_record') != 'true')
      new Ajax.Request('/videos/' + this.video_id + '/tags/' + vtag.readAttribute('tag_id'), {method: 'delete'});

    vtag.remove();
  },

  /*
   * save
   */
  save: function(){
    // construct url
    // appending form inputs and tag inputs
    var url = '/users/' + this.user_id + '/videos?';
    this.vtags.each(function(pair){
      if(pair.value.readAttribute('new_record') == 'true')
        url += "tagged_users[]=" + pair.key + "&";
    });
    url += this.form.serialize();
    
    // send ajax request
    new Ajax.Request(url, {method: 'post'});
  },

  /*
   * update as blog or draft which is determined by type
   * this function also needs blog id or draft id
   */
  update: function(id){
    // construct url
    // appending form inputs and tag inputs
    var url = '/users/' + this.user_id + '/videos/' + id + '?';
    this.vtags.each(function(pair){
      if(pair.value.readAttribute('new_record') == 'true')
        url += "tagged_users[]=" + pair.key + "&";
    });
    url += this.form.serialize();

    // send ajax request
    new Ajax.Request(url, {method: 'put'});  
  },
  
})

function after_tag(input_field, selected_li){
  video_builder.new_tag(selected_li.readAttribute('user_id'));
  video_builder.tag_input.value = '';
}

function play_video(video_id, video_link){
  $('video_' + video_id).innerHTML = video_link;
}




