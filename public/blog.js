PopupManager = Class.create({

  /*
   * initialize
   */
  initialize: function(user_id, options){
    this.user_id = user_id;

    // read options
    this.options = Object.extend({
      popup_class: 'popup-class',
      user_info_class: 'popup-user-info-class',
    }, options || {});
  },

  /*
   * popup user information
   */
  show: function(user_id, linker){
    if(this.popup)
      this.popup.hide();
    else{
      // create popup element and close button
      this.popup = new Element('div', {className: this.options.popup_class});
      this.user_info = new Element('div', {className: this.options.user_info_class});
      this.close_button = new Element('button');
      this.close_button.update('close');
      this.popup.appendChild(this.user_info);
      this.popup.appendChild(this.close_button);

      // add click event to close button
      this.close_button.observe('click', function(event){
        this.popup.hide();
      }.bind(this));
    }

    // record position and user_id
    this.pos = linker.positionedOffset();
    this.pos.left += linker.getWidth();

    // send ajax request to server to retrieve user info
    new Ajax.Request("/users/" + this.user_id + '/blogs/show_popup_tag?tagged_user_id='+user_id, {
      method: 'get',
      onSuccess: function(transport){
        this.user_info.innerHTML = transport.responseText;
        this.popup.setStyle({
          position: 'absolute',
          left: this.pos.left + 'px',
          top: this.pos.top + 'px',
          backgroundColor: '#fff'
        });
        document.body.appendChild(this.popup);
        this.popup.show();
      }.bind(this)
    });
  }

});


/**
 * blog builder
 **/
BlogBuilder = Class.create({
  
  /*
   * initialize
   */
  initialize: function(user_id){
    // save user id and blog id
    this.user_id = user_id;
    
    // save tag input field and set its initial text
    this.tag_input = $('blog_tags');
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
    this.form = $('blog_input'); 

    // save btags div which displays all current btags
    this.btags_div = $('btags');

    // fold, unfold handler
    this.unfold = $('unfold');
  },

  /*
   * new tag
   * pay attention that this tag is not stored in database until you click 'save' or 'save as draft'
   */
  new_tag: function(input_field, selected_li){
    // store friend id which is stored as li element attribute
    var tagged_user_id = selected_li.readAttribute("user_id");
    
    // send ajax request to retrieve user information(icon, name ... so on)
    new Ajax.Request('/users/' + this.user_id + '/blogs/new_tag?tagged_users[]=' + tagged_user_id, {
      method: 'get',
      onSuccess: function(transport){
        this.btags_div.innerHTML += transport.responseText;
        this.tag_input.value = '';
      }.bind(this)
    }); 
  },

  /*
   * remove tag
   */
  remove_tag: function(btag, new_record, tag_id){
    // if it's not a new record, it means it stores in database,
    // then do an ajax request to remove it from database
    if(!new_record){
      alert("old record")
      new Ajax.Request('/users/' + this.user_id + '/blogs/remove_tag?tag_id=' + tag_id, {method: 'delete'});
    }

    btag.remove();
  },

  /*
   * save as blog or draft which is determined by type
   */
  save: function(type){
    // construct url
    // appending form inputs and tag inputs
    var url = '/users/' + this.user_id + '/blogs?';
    if(type == 'blog')
      url += "blog[draft]=0&"
    else
      url += "blog[draft]=1&"
    var btags = this.btags_div.childElements();
    var length = btags.length;
    for(var i=0;i < length; i++){
      if(btags[i].readAttribute('new_record') == 'true')
        url += "tagged_users[]=" + btags[i].readAttribute('tagged_user_id') + "&";
    }
    url += this.form.serialize();alert(url);
    
    // send ajax request
    new Ajax.Request(url, {
      method: 'post',
      onSuccess: function(transport){
        window.location.href = transport.responseText;
      }
    });
  },

  /*
   * update as blog or draft which is determined by type
   * this function also needs blog id or draft id
   */
  update: function(type, id){
    // construct url
    // appending form inputs and tag inputs
    var url = '/users/' + this.user_id + '/blogs/' + id + '?';
    if(type == 'blog')
      url += "blog[draft]=0&"
    else
      url += "blog[draft]=1&"
    var btags = this.btags_div.childElements();
    var length = btags.length;
    for(var i=0;i < length; i++){
      if(btags[i].readAttribute('new_record') == 'true'){
        url += "tagged_users[]=" + btags[i].readAttribute('tagged_user_id') + "&";
      }
    }

    url += this.form.serialize();

    // send ajax request
    new Ajax.Request(url, {
      method: 'put',
      onSuccess: function(transport){
        window.location.href = transport.responseText;
      }
    });  
  },

  /*
   * save blog
   */
  save_blog: function(){
    this.save('blog');
  },

  /*
   * save draft
   */
  save_draft: function(){
    this.save('draft');
  },

  /*
   * update blog
   */
  update_blog: function(blog_id){
    this.update('blog', blog_id);
  },

  /*
   * update draft
   */
  update_draft: function(draft_id){
    this.update('draft', draft_id);
  },

  /*
   * return an array of tagged users id
   */
  get_tagged_users: function(){
    var inputs = $$('input');
    var length = inputs.length;
    var tagged_users = [];
    for(var i = 0; i < length; i++){
      if(inputs[i].type == 'checkbox' && inputs[i].checked){
        tagged_users.push(inputs[i].value);
      }
    }
    return tagged_users;
  },

  /*
   * return relevant games
   */
  get_games: function(){
    // send ajax request to retrieve all the games
    new Ajax.Request('/users/' + this.user_id + '/blogs/games_list', {
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
    new Ajax.Request('/users/' + this.user_id + '/blogs/friends_list?game_id=' + game_id, {
      method: 'get',
      onSuccess: function(transport){
        this.friends_list.innerHTML = transport.responseText;
      }.bind(this)
    });
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
        this.popup.hide();
        return;
      }

      // construct parameters and url
      var url = '/users/' + this.user_id + '/blogs/new_tag?';
      for(var i=0;i<tagged_users.length;i++){
        url += "tagged_users[]=" + tagged_users[i] + "&";
      }

      // send ajax request to retreive user info
      // note that at this time, the tags are not stored in database yet
      new Ajax.Request(url, {
        method: 'get',
        onSuccess: function(transport){
          this.btags_div.innerHTML += transport.responseText;
          this.popup.hide();
        }.bind(this)
      });
    }.bind(this));
  },

  /*
   * show friends
   */
  show_friends: function(){
    // if the popup frame exists, we just show it
    if(this.popup){
      this.popup.show();
    }else{
alert("begin");
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
alert("set button event");
    // add click event to confirm button
    this.set_button_event();
alert("get games");
    // send ajax request to retrieve all the games
    this.get_games();
alert("get friends");
    // send ajax request to retrieve all friends
    this.get_friends('all'); 
alert("set style");
    // add popup element to document
    document.body.appendChild(this.popup);
    this.popup.hide();
 
    // set friend list style
    this.friends_list.setStyle({
      width: '350px',
      height: '150px',
      overflow: 'auto'
    });
alert("show");
    // set popup frame position
    this.popup.setStyle({
      position: 'absolute',
      left: (this.unfold.positionedOffset().left - 350) + 'px',
      top: this.unfold.positionedOffset().top + 'px',
    });

    this.popup.show();
    }
/*    this.unfold.update('fold');
    this.unfold.stopObserving('click');
    this.unfold.observe('click', function(){
      this.hide_friends();
    }.bind(this));*/
  },

  /*
   * hide friends list
   */
  hide_friends: function(){
    this.popup.hide();
    this.unfold.update('unfold');
    this.unfold.stopObserving('click');
    this.unfold.observe('click', function(){
      this.show_friends():
    }.bind(this));
  }
});

function after_tag(input_field, selected_li){
  blog_builder.new_tag(input_field, selected_li);
}

DraftManager = Class.create({

  /*
   * initialize
   * just save drafts element
   */
  initialize: function(user_id){
    this.drafts = $('my_drafts');
    this.user_id = user_id;
  },

  /*
   * get all selected drafts
   */
  get_selected: function(){
    var selected = [];
    var inputs = $$('input');
    for(var i=0;i<inputs.length;i++){
      if(inputs[i].type == 'checkbox' && inputs[i].checked){
        selected.push(inputs[i]);
      }
    }
    return selected;
  },

  /*
   * get all drafts
   */
  get_all: function(){
    var all = [];
    var inputs = $$('input');
    for(var i=0;i<inputs.length;i++){
      if(inputs[i].type == 'checkbox'){
        all.push(inputs[i]);
      }
    }
    return all;
  },

  /*
   * select all drafts
   * set all checkboxes to true
   */
  select_all: function(){
    var all = this.get_all();
    for(var i=0;i<all.length;i++){
      all[i].checked=true;
    }
  },

  /*
   * delete selected drafts
   */
  delete_selected: function(){
    var selected = this.get_selected();
    
    // construct url
    url = "/users/" + this.user_id + "/blogs/delete?";
    for(var i=0;i<selected.length;i++){
      url += "blogs[]=" + selected[i].readAttribute('blog_id') + "&";
    }
    alert(url);
 
    // send ajax request to remove it from database
    new Ajax.Request(url, {
      method: 'delete',
      onSuccess: function(transport){
        window.location.href = transport.responseText;
      }
    });
  } 
});
