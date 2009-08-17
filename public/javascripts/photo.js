PhotoTag = Class.create({

  /*
   * initialize
   */
  initialize: function(photo_id, user_id, options){
    // save user id, photo element and its position
    this.user_id = user_id;
    this.photo_id = photo_id;
    this.photo = $('photo_' + this.photo_id);
    this.pos = this.photo.positionedOffset();
   
    // save complete panel
    this.complete_panel = $('complete_panel');
    
    // log, this is only used for debugging
    this.log = $('log');
 
    // get the area where tags are shown
    this.tags_area = $('photo_tags');

    // photo tag options
    this.options = Object.extend({
        square_size: '15%',
	square_class: 'square-class',
	tag_input_class: 'tag-input',
	tag_class: 'tag_class',
        friends_list_class: 'friends_list_class',
	lang: {  // name for two buttons
		add: 'Add',
		close: 'Close'
	},
    }, options || {});

    // calculate square size
    this.square_size = this.photo.getWidth() * this.options.square_size.sub('%', '', 1)/100;

    this.friends = [];
    
    // set window resize handler
    // reset photo position if resize event happens
    Event.observe(document.onresize? document : window, 'resize', function(){
      this.pos = this.photo.positionedOffset();
    }.bind(this));

    // get all current tags
    this.ptags = new Hash();
    var ptags = $('photo_tags').childElements();
    var length = ptags.length;
    for(var i=0;i<length;i++){
      this.ptags.set(ptags[i].readAttribute('tag_id'), ptags[i]);
    } 

    // set photo mouseover event
    this.photo.observe('mouseover', function(event){
      
    }.bind(this));
  },

  /*
   * add info to log
   * this function is only used for debugging
   */
  add_log: function(str){
    this.log.innerHTML += (str + '<br/>');
  },

  /*
   * init: begin tagging
   */
  init: function(){
    // show complete panel
    this.complete_panel.show(); 

    // I dont know if this field is needed,
    // because sometimes mouse up event would happen two times( i dont know why)
    // this would cause "new draggable()" called twice
    this.draggable_count = 0;

    // if square and tag input exist, we dont need to create them
    // just hide them
    if(this.square && this.tag_input){
      this.hide_square();
      this.hide_tag_input();
    }else{
      // create square and input box
      this.create_square();   
      this.create_tag_input();
    } 

    // add onClick event to photo
    Event.observe(this.photo, 'click', function(event){
      this.set_square(event);
    }.bind(this));
  },

  /*
   * create square
   * this function just creates square element but doesn't set its position
   */
  create_square: function(){
    // create square
    this.square = new Element('div', {className: this.options.square_class});

    // set square style
    this.square.setStyle({
	position: 'absolute',
	left: '0px',
	top: '0px',
	height: this.square_size + 'px',
	width: this.square_size + 'px'}); 

    // create leftup corner
    this.create_leftup_corner();

    // create leftdown corner
    this.create_leftdown_corner();

    // create rightup corner
    this.create_rightup_corner();

    // create rightdown corner
    this.create_rightdown_corner();

    // hide square and add it to 
    this.hide_square();
    document.body.appendChild(this.square);
  },

  /*
   * create leftup corner of square
   * this function just creates square element but doesn't set its position
   */
  create_leftup_corner: function(){
    // create div element
    this.leftup_corner = new Element('div', {id: 'leftup-corner'});
    this.square.appendChild(this.leftup_corner);

    // set mouse over listener to change cursor icon
    this.leftup_corner.observe('mouseover', function(event){
      document.body.setStyle({cursor: 'nw-resize'});
    });

    // set mouse out listener to change cursor icon to default one
    this.leftup_corner.observe('mouseout', function(event){
      document.body.setStyle({cursor: 'default'});
    });

    // set mouse down listener to start resize
    this.leftup_corner.observe('mousedown', function(event){
      // save original position and size
      this.start_x = event.pointerX();
      this.start_y = event.pointerY();
      this.original_height = this.square.getHeight();
      this.original_width = this.square.getWidth();

      // disable dragging while resizing
      this.disable_drag();

      // start listening for mouse move event
      document.body.observe('mousemove', function(event){
        var width = this.square.getWidth();
        var height = this.square.getHeight();

        // recording end position and make sure that it stays in photo
        var xy = this.stay_in_photo(event.pointerX(), event.pointerY());
        var x = xy[0];
        var y = xy[1];

        // resize square
        this.square.setStyle({
          left: x + 'px',
          top: y + 'px',
          width: (this.original_width + this.start_x - x) + 'px',
          height: (this.original_height + this.start_y - y) + 'px',
        });

         // reset positions of 4 corners
         this.set_corners();

         // reset position of tag input
         this.set_tag_input();
      }.bind(this));
      document.body.observe('mouseup', function(event){
        this.enable_drag();
        Event.stopObserving(document.body, 'mousemove');
        Event.stopObserving(document.body, 'mouseup');
      }.bind(this));
    }.bind(this));
  },

  /*
   * create leftdown corner of square
   * this function just creates square element but doesn't set its position
   */
  create_leftdown_corner: function(){
    // create div element
    this.leftdown_corner = new Element('div', {id: 'leftdown-corner'});
    this.square.appendChild(this.leftdown_corner);

    // set mouse over listener to change cursor icon
    this.leftdown_corner.observe('mouseover', function(event){
      document.body.setStyle({cursor: 'sw-resize'});
    });

    // set mouse out listener to change cursor icon to default one
    this.leftdown_corner.observe('mouseout', function(event){
      document.body.setStyle({cursor: 'default'});
    });

    // set mouse down listener to start resize
    this.leftdown_corner.observe('mousedown', function(event){
      // save original position and size
      this.start_x = event.pointerX();
      this.start_y = event.pointerY();
      this.original_height = this.square.getHeight();
      this.original_width = this.square.getWidth();

      // disable dragging while resizing
      this.disable_drag();

      // start listening for mouse move event
      document.body.observe('mousemove', function(event){
        var width = this.square.getWidth();
        var height = this.square.getHeight();

        // recording end position and make sure that it stays in photo
        var xy = this.stay_in_photo(event.pointerX(), event.pointerY() - height);
        var x = xy[0];
        var y = xy[1] + height;;

        // resize square
        this.square.setStyle({
          left: x + 'px',
          width: (this.original_width + this.start_x - x) + 'px',
          height: (this.original_height + y - this.start_y) + 'px',
        });

         // reset positions of 4 corners
         this.set_corners();

         // reset position of tag input
         this.set_tag_input();
      }.bind(this));
      document.body.observe('mouseup', function(event){
        this.enable_drag();
        Event.stopObserving(document.body, 'mousemove');
        Event.stopObserving(document.body, 'mouseup');
      }.bind(this));
    }.bind(this));
  },

  /*
   * create rightup corner of square
   * this function just creates square element but doesn't set its position
   */
  create_rightup_corner: function(){
    // create div element
    this.rightup_corner = new Element('div', {id: 'rightup-corner'});
    this.square.appendChild(this.rightup_corner);

    // set mouse over listener to change cursor icon
    this.rightup_corner.observe('mouseover', function(event){
      document.body.setStyle({cursor: 'ne-resize'});
    });

    // set mouse out listener to change cursor icon to default one
    this.rightup_corner.observe('mouseout', function(event){
      document.body.setStyle({cursor: 'default'});
    });

    // set mouse down listener to start resize
    this.rightup_corner.observe('mousedown', function(event){
      // save original position and size
      this.start_x = event.pointerX();
      this.start_y = event.pointerY();
      this.original_height = this.square.getHeight();
      this.original_width = this.square.getWidth();

      // disable dragging while resizing
      this.disable_drag();

      // start listening for mouse move event
      document.body.observe('mousemove', function(event){
        var width = this.square.getWidth();
        var height = this.square.getHeight();

        // recording end position and make sure that it stays in photo
        var xy = this.stay_in_photo(event.pointerX() - width, event.pointerY());
        var x = xy[0] + width;
        var y = xy[1];

        // resize square
        this.square.setStyle({
          top: y + 'px',
          width: (this.original_width + x - this.start_x) + 'px',
          height: (this.original_height + this.start_y - y) + 'px',
        });

         // reset positions of 4 corners
         this.set_corners();

         // reset position of tag input
         this.set_tag_input();
      }.bind(this));
      document.body.observe('mouseup', function(event){
        this.enable_drag();
        Event.stopObserving(document.body, 'mousemove');
        Event.stopObserving(document.body, 'mouseup');
      }.bind(this));
    }.bind(this));
  },

  /*
   * create rightdown corner of square
   * this function just creates square element but doesn't set its position
   */
  create_rightdown_corner: function(){
    // create div element
    this.rightdown_corner = new Element('div', {id: 'rightdown-corner'});
    this.square.appendChild(this.rightdown_corner);

    // set mouse over listener to change cursor icon
    this.rightdown_corner.observe('mouseover', function(event){
      document.body.setStyle({cursor: 'se-resize'});
    });

    // set mouse out listener to change cursor icon to default one
    this.rightdown_corner.observe('mouseout', function(event){
      document.body.setStyle({cursor: 'default'});
    });

    // set mouse down listener to start resize
    this.rightdown_corner.observe('mousedown', function(event){
      // save original position and size
      this.start_x = event.pointerX();
      this.start_y = event.pointerY();
      this.original_height = this.square.getHeight();
      this.original_width = this.square.getWidth();

      // disable dragging while resizing
      this.disable_drag();

      // start listening for mouse move event
      document.body.observe('mousemove', function(event){
        var width = this.square.getWidth();
        var height = this.square.getHeight();

        // recording end position and make sure that it stays in photo
        var xy = this.stay_in_photo(event.pointerX() - width, event.pointerY() - height);
        var x = xy[0] + width;
        var y = xy[1] + height;

        // resize square
        this.square.setStyle({
          width: (this.original_width + x - this.start_x) + 'px',
          height: (this.original_height + y - this.start_y) + 'px',
        });

         // reset positions of 4 corners
         this.set_corners();

         // reset position of tag input
         this.set_tag_input();
      }.bind(this));
      document.body.observe('mouseup', function(event){
        this.enable_drag();
        Event.stopObserving(document.body, 'mousemove');
        Event.stopObserving(document.body, 'mouseup');
      }.bind(this));
    }.bind(this));
  },

  /*
   * hide square
   */
  hide_square: function(){
    this.square.hide();
  },

  /*
   * show square
   */
  show_square: function(){
    this.square.show();
  },

  /*
   * hide tag input
   */
  hide_tag_input: function(){
    this.inner_textfield.value = '';
    this.tag_input.hide();
  },

  /*
   * show tag input
   */
  show_tag_input: function(){
    this.tag_input.show();
    this.inner_textfield.focus();
  },

  /*
   * this function guarantees that the square stays in photo area
   * take care when invoking this function: (x, y) is (left, top) of square
   * thus do the convertion before invoking this function
   */
  stay_in_photo: function(x, y){
    // lb: left bound, rb: right bound, ub: upper bound, bb: lower bound
    var lb = this.pos.left - this.square.getWidth()/2;
    var rb = this.pos.left + this.photo.getWidth() - this.square.getWidth()/2;
    var ub = this.pos.top - this.square.getHeight()/2;
    var bb = this.pos.top + this.photo.getHeight() - this.square.getHeight()/2;

    // make sure the square stays in photo area
    if(x < lb)
      x = lb;
    if(x > rb)
      x = rb;
    if(y < ub)
      y = ub;  
    if(y > bb)
      y = bb;

    return [x,y];
  },

  /*
   * enable draggable
   */
  enable_drag: function(){
    // if there is no draggable object
    if(this.draggable_count == 0){
      this.draggable_count += 1;
      this.draggable = new Draggable(this.square, {
        snap: function(x, y, draggable){
          var xy = this.stay_in_photo(x, y);
          this.square.setStyle({
            left: xy[0] + 'px',
            top: xy[1] + 'px'
          });
          this.set_tag_input();
          return xy;
        }.bind(this)
      });
    }
  },

  /*
   * disable draggable
   */
  disable_drag: function(){
    // if there is one draggable object
    if(this.draggable_count == 1){
      this.draggable.destroy();
      this.draggable_count -= 1;
    }
  },

  /*
   * create tag input but not show it
   * this function just creates tag input but doesn't set its position
   * html code looks like:
   * <div>
   *   <div> hidden text field which stores tagged user id </div>
   *   <div>
   *     Input your friend: <br/>
   *     <text_field>
   *   </div>
   *   <div> friend list </div>
   *   <div> 2 buttons </div>
   * </div>
   */
  create_tag_input: function(){
    // create tag input
    this.tag_input = new Element('div', {className: this.options.tag_input_class});
    this.tag_input_hidden = new Element('div');
    this.hidden_textfield = new Element('input', {type: 'text', id: 'tagged_user_id'});
    this.tag_input_top = new Element('div');
    this.label = new Element('label').update('Input your friend here:<br/>'); 
    this.inner_textfield = new Element('input', {type: 'text', id: 'tagged_user_name'});
    this.friend_list = new Element('div');
    this.tag_input_bot = new Element('div');
    //this.confirm_button = new Element('button').update('confirm');
    this.cancel_button = new Element('button').update('cancel');

    this.tag_input_hidden.appendChild(this.hidden_textfield);
    this.tag_input_top.appendChild(this.label);
    this.tag_input_top.appendChild(this.inner_textfield);
    //this.tag_input_bot.appendChild(this.confirm_button);
    this.tag_input_bot.appendChild(this.cancel_button);
    this.tag_input.appendChild(this.tag_input_hidden);
    this.tag_input.appendChild(this.tag_input_top);
    this.tag_input.appendChild(this.friend_list);
    this.tag_input.appendChild(this.tag_input_bot);

    this.tag_input_hidden.hide();
    this.friend_list.setStyle({
      height: '200px',
      overflow: 'auto'
    });
   
    this.tag_input_top.setStyle({
      margin: '10px'
    });

    this.tag_input_bot.setStyle({
      margin: '10px',
      align: 'center'
    });

    this.tag_input.setStyle({
      background: 'white'
    });
 
    // get all friends
    this.get_friends();

    // set button events
    this.set_button_events();

    // set text field observer
    this.set_textfield_observer();

    // hide the element and add it to document.body
    // hide_tag_input() should be invoked after tag_input.inner_textfield is created
    this.hide_tag_input();
    document.body.appendChild(this.tag_input);
  },

  get_selected_friend_id: function(){
    var length = this.friends.length;
    for(var i=0;i<length;i++){
      var friend = this.friends[i];
      var checkbox = friend.childElements()[0];
      if(checkbox.checked){
        checkbox.checked = false;
        return friend.readAttribute('id');
      }
    }
  },

  /*
   * get all friends
   */
  get_friends: function(){
    new Ajax.Request('/album_photos/friends', {
      method: 'get',
      onSuccess: function(transport){
        this.friend_list.innerHTML = transport.responseText;
        var friends = this.friend_list.childElements();
        var length = friends.length;
        for(var i=0;i<length;i++){
          var checkbox = friends[i].childElements()[0];
          checkbox.observe('click', function(event){
            var id = this.get_selected_friend_id();
            this.submit_tag(id);
          }.bind(this));
          this.friends.push(friends[i]);
        }
      }.bind(this)
    });
  },

  /*
   * set textfield observer
   */
  set_textfield_observer: function(){
    new Form.Element.Observer(this.inner_textfield, 1, function(element, value){
      var length = this.friends.length;
      for(var i=0;i<length;i++){
        friend = this.friends[i];
        if(friend.readAttribute('name').indexOf(value) < 0){
          friend.hide();
        }else{
          friend.show();
        }
      } 
    }.bind(this)); 
  },

  /*
   * set add/close button events
   */
  set_button_events: function(){
    this.cancel_button.observe('click', function(event){
      this.hide_square();
      this.hide_tag_input();
    }.bind(this)); 
  },

  /*
   * submit tag
   */
  submit_tag: function(tagged_user_id){
    // get square position
    var left = this.square.positionedOffset().left;
    var top = this.square.positionedOffset().top;

    // construct parameters
    url = '/photos/' + this.photo_id + '/tags?' + 
          'tag[x]=' + (left - this.pos.left) + '&' +
          'tag[y]=' + (top - this.pos.top) + '&' +
          'tag[width]=' + this.square.getWidth() + '&' +
          'tag[height]=' + this.square.getHeight() + '&' +
          'tag[tagged_user_id]=' + tagged_user_id + '&' +
          'tag[photo_id]=' + this.photo_id;
    
    // send ajax request to store photo tag
    new Ajax.Request(url, {
      method: 'post',
      onSuccess: function(transport){
        this.tags_area.innerHTML += transport.responseText;
        this.hide_square();
        this.hide_tag_input();
        var ptags = this.tags_area.childElements();
        var length = ptags.length;
        for(var i=0;i<length;i++){
          this.ptags.set(ptags[i].readAttribute('tag_id'), ptags[i])
        }
      }.bind(this)
    });
  },

  /*
   * set the location of square
   */
  set_square: function(event){
    // get mouse location
    var mouse_x = event.pointerX();
    var mouse_y = event.pointerY();

    // calculate square location
    var square_top = mouse_y - this.square_size/2;
    var square_left = mouse_x - this.square_size/2;

    // pay attention to the orders
    // first set square position, then 4 corners and tag input

    // set square location and show it
    this.square.setStyle({
	position: 'absolute',
	width: this.square_size + 'px',
	height: this.square_size + 'px',
	top: square_top + 'px',
	left: square_left + 'px',
	zIndex: 4});
  
    // show square
    this.show_square();

    // set 4 corners
    this.set_corners();

    // set tag input
    this.set_tag_input();

    // enable draggable
    this.enable_drag();
  },

  /*
   * set positions of 4 corners
   */
  set_corners: function(){
    // get x, y, width, height of square and corner size
    var width = this.square.getWidth();
    var height = this.square.getHeight();
    var corner_size = 10;

    // set position of 4 corners
    this.leftup_corner.setStyle({
        position: 'absolute',
        backgroundColor: '#000',
        left: '0px',
        top: '0px',
        width: corner_size + 'px',
        height: corner_size + 'px',
        zIndex: 4});
    this.leftdown_corner.setStyle({
        position: 'absolute',
        backgroundColor: '#000',
        left: '0px',
        top: (height - corner_size) + 'px',
        width: corner_size + 'px',
        height: corner_size + 'px',
        zIndex: 4});
    this.rightup_corner.setStyle({
        position: 'absolute',
        backgroundColor: '#000',
        left: (width - corner_size) + 'px',
        top: '0px',
        width: corner_size + 'px',
        height: corner_size + 'px',
        zIndex: 4});
    this.rightdown_corner.setStyle({
        position: 'absolute',
        backgroundColor: '#000',
        left: (width - corner_size) + 'px',
        top: (height - corner_size) + 'px',
        width: corner_size + 'px',
        height: corner_size + 'px',
        zIndex: 4});
  },

  /*
   * show tag input according to the position of square
   */
  set_tag_input: function(event){
    // calculate the position of tag input
    var top = this.square.positionedOffset().top;
    var left = this.square.positionedOffset().left + this.square.getWidth() + 10;

    // set style
    this.tag_input.setStyle({
	position: 'absolute',
	top: top + 'px',
        left: left + 'px',
        zIndex: 4});

    // show tag input and set the focus of inner text field
    this.show_tag_input();
  },

  /*
   * delete one tag
   */
  delete: function(tag_id){
    var square = $('square_' + tag_id);
    var tag_link = $('tag_'+tag_id);

    // delete square
    if(square)
      square.remove();

    // delete tag link
    tag_link.remove();
  },

  /*
   * hide one tag
   */
  hide_tag: function(tag_id){
    var square = $('square_' + tag_id);
    if(square)  square.hide();
  },

  /*
   * show one tag
   */
  show_tag: function(tag_id){
    var square = $('square_'+tag_id);

    // if it's first time we visit this tag, create a new square
    // otherwise, just show the old square
    if(square){
      square.show();
      return;
    }

    // calculate x, y, width, height
    // here, we just save these values as element attributes
    // rather than connect server
    var ptag = this.ptags.get(tag_id);
    if(!ptag) return;
    var x = ptag.readAttribute('x');
    var y = ptag.readAttribute('y');
    var width = ptag.readAttribute('width');
    var height = ptag.readAttribute('height');
    var top = parseInt(y) + this.pos.top;
    var left = parseInt(x) + this.pos.left;
    
    // create new square
    square = new Element('div', {className: 'square-class', id: 'square_' + tag_id});
    
    // set square style
    square.setStyle({
	position: 'absolute',
        width: width + 'px',
        height: height + 'px',
        left: left + 'px',
        top: top + 'px',
        zIndex: 3});

    // append square
    document.body.appendChild(square);
  
    // add mouseout event to tag link
    Event.observe(tag_link, 'mouseout', function(){
      var square = $('square_' + tag_id);
      square.hide();
    });
  },

  /*
   * complete tagging
   */
  complete: function(){
    // hide complete panel
    this.complete_panel.hide();

    // hide square and tag input
    this.hide_square();
    this.hide_tag_input();

    // stop listening for photo click event
    this.photo.stopObserving('click'); 
  }
});

