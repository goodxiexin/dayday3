function after_select(input_field, selected_li){
  participation_builder.new_participation(selected_li.readAttribute('user_id'));
  $('event_participations').value = '';
}


ParticipationBuilder = Class.create({
  initialize: function(user_id, event_id){
    this.user_id = user_id;
    this.event_id = event_id;

    this.participation_input = $('event_participations');
    this.participation_input.value = 'please tag your friend here';

    this.participation_input.observe('focus', function(event){
      this.value = '';
    });

    this.participation_input.observe('blur', function(event){
      this.value = 'please tag your friends here';
    });

    this.participations_div = $('participations');
    this.friends_list=$('friends');

    this.participations = new Hash();
    var current_participations = this.participations_div.childElements();
    for(var i=0;i<current_participations.length;i++){
      this.participations.set(current_participations[i].readAttribute('participant_id'), current_participations[i]);
    }
  },

  after_select: function(input_field, selected_li){
    this.new_participation(selected_li.readAttribute('user_id'));
    $('event_participations').value = '';
  },

  new_participation: function(participant_id){
    // if this user is already in participation list, skip it
    if(this.participations.get(participant_id)) return;
    // send ajax request to retrieve user information(icon, name ... so on)
    new Ajax.Request('/participations/new_participation?participants[]=' + participant_id, {
      method: 'get',
      onSuccess: function(transport){
        this.participations_div.innerHTML = transport.responseText + this.participations_div.innerHTML;
        this.participation_input.value = '';
        var children = this.participations_div.childElements();
        var length = children.length;
        for(var i=0;i<length;i++){
          this.participations.set(children[i].readAttribute('participant_id'), children[i]);
        }
      }.bind(this)
    });
  },

  remove_participation: function(participant_id){
    var participation = this.participations.unset(participant_id);
    if(!participation) return;

    // if it's not a new record, it means it stores in database,
    // then do an ajax request to remove it from database
    if(participation.readAttribute('new_record') != 'true')
      new Ajax.Request('/participations/' + participation.readAttribute('participation_id'), {method: 'delete'});

    participation.remove();
  },

  game_select: function(game_id){
    new Ajax.Request('/participations/friends_list?game_id=' + game_id, {
      method: 'get',
      onSuccess: function(transport){
        this.friends_list.innerHTML = transport.responseText;
      }.bind(this)
    });
  },

  get_selected_users: function(){
    var inputs = $$('input');
    var length = inputs.length;
    var selected_users = [];
    for(var i = 0; i < length; i++){
      if(inputs[i].type == 'checkbox' && inputs[i].checked && !this.participations.get(inputs[i].value)){
        selected_users.push(inputs[i].value);
      }
    }
    return selected_users;
  },

  confirm_event: function(){
    var selected_users = this.get_selected_users();
    if (selected_users.length != 0 ){
      var url = '/participations/new_participation?';
      for(var i=0;i<selected_users.length;i++){
        url += "participants[]=" + selected_users[i] + "&";
      }

      new Ajax.Request(url, {
        method: 'get',
        onSuccess: function(transport){
          this.participations_div.innerHTML = transport.responseText + this.participations_div.innerHTML;
          var children = this.participations_div.childElements();
          var length = children.length;
          for(var i=0;i<length;i++){
            this.participations.set(children[i].readAttribute('participant_id'), children[i]);
          }
        }.bind(this)
      });
    }
  },

  save: function(event_id){
    // construct url
    // appending participant inputs
    var url = '/participations?event_id='+event_id+'&';
    this.participations.each(function(pair){
      if(pair.value.readAttribute('new_record') == 'true')
        url += "participants[]=" + pair.key + "&";
    });
    // send ajax request
    new Ajax.Request(url, {method: 'post'});
  },

});
