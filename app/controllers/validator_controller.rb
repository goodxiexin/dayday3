class ValidatorController < ApplicationController

  def validates_email_uniqueness
    if User.find_by_email(params[:email])
      render :text => 'no'
    else
      render :text => 'yes'
    end
  end

end
