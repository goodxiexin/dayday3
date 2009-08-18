require 'active_record'

module ModelHelper

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

ActiveRecord::Base.extend(ModelHelper)
