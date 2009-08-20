class ParticipationsController < ApplicationController
  layout 'event'
  def index
  end

  def new
    event_id = params[:event_id]
    @event = Event.find(event_id)
    @user = current_user
  end

  def create
  end

  def new_participation
    participations = []
    params[:participants].each do |participant_id|
      participations << Participation.new(:participant_id => participant_id)
    end
    render :partial => "participants", :collection => participations
  end

  def auto_complete_for_event_participations
    logger.error('auto_complete has been run') 
    @user = current_user 
    @friends = @user.friends.find_all {|f| f.login.include?(params[:event][:participations]) }
    render :partial => 'friends' 
  end     

end
