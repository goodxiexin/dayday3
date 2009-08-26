# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include AuthenticatedSystem 

  include VisitorRecordSystem

  def new_validation_image
    validation_image = ValidationImage.new
    session[:validation_text] = validation_image.text
    send_data validation_image.image, :type => 'image/jpeg', :disposition => 'inline'
  end 

  def get_page(array, page)
    page = 1 if page == nil
    WillPaginate::Collection.create(page, 10) do |pager|
      result = []
      10.times do |i|
        (i + pager.offset >= array.count)? break : result << array[i + pager.offset]
      end
      pager.replace(result)
      pager.total_entries = array.count
    end
  end
 
end
