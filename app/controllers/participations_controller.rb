class ParticipationsController < ApplicationController
  layout 'event'
  def index
  end

  def new
    event_id = params[:event_id]
    @event = Event.find(event_id)
    @user = current_user
    @games = Game.all
  end

  def create
    @event = Event.find(params[:event_id])
    params[:participants].each do |participant_id|
      @event.participations.create(:participant_id => participant_id, :inviter_id => current_user.id)
    end unless params[:participants].blank?
    flash[:notice] = "successfully invited your friends"
    render :update do |page|
      page.redirect_to event_url(@event)
    end
  end

  def new_participation
    participations = []
    params[:participants].each do |participant_id|
      participations << Participation.new(:participant_id => participant_id)
    end
    render :partial => "participation", :collection => participations
  end

  def friends_list                                                            
    @user  = current_user                                                     
    if params[:game_id].blank?                                              
      @friends = @user.friends                                                
    else                                                                      
      game = Game.find(params[:game_id])                                      
      @friends = @user.friends.find_all {|f| f.games.include?(game) }         
    end 
    render :partial => 'friends_list', :object => @friends                    
  end    

  def auto_complete_for_event_participations
    @user = current_user 
    @friends = @user.friends.find_all {|f| f.login.include?(params[:event][:participations]) }
    render :partial => 'friends' 
  end     

end
