ActionController::Routing::Routes.draw do |map|

  map.resources :sessions

  map.root :controller => 'sessions', :action => 'new'

  map.signup '/signup', :controller => 'users', :action => 'new'

  map.login '/login', :controller => 'sessions', :action => 'new'

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'

  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'

  map.reset_password '/reset_password/:password_reset_code', :controller => 'passwords', :action => 'edit'

  map.change_password '/change_password', :controller => 'accounts', :action => 'edit'

  map.upload_image '/upload_images', :controller => 'user/blog_images', :action => 'upload'

  map.namespace(:admin) do |admin|
    admin.resources :videos

    admin.resources :vtags

    admin.resources :vdigs

    admin.resources :vcomments

    admin.resources :blogs
 
    admin.resources :btags

    admin.resources :bdigs

    admin.resources :bcomments

    admin.resources :albums

    admin.resources :photos

    admin.resources :ptags

    admin.resources :pdigs

    admin.resources :pcomments

    admin.resources :pages

    admin.resources :statuses

    admin.resources :scomments

    admin.resources :wall_messages

    admin.resources :mails

    admin.resources :friendships

    admin.resources :game_characters

    admin.resources :game_races

    admin.resources :game_professions

    admin.resources :game_servers

    admin.resources :game_areas

    admin.resources :games
  end


  map.resources :users, :member => {:enable => :put} do |users|
    users.resource :personal,
                   :controller => 'user/personal'

    users.resource :profile,
                   :controller => 'user/profile'

    users.resource :basic_info,
                   :controller => 'user/basic_info'

    users.resource :contact_info,
                   :controller => 'user/contact_info'

    users.resources :icons,
                    :controller => 'user/icons',
                    :member => {:confirm_destroy => :get, :set => :post}

    users.resources :characters,
                    :controller => 'user/characters',
                    :member => {:confirm_destroy => :get}

    users.resources :wall_messages, 
                    :controller => 'user/wall_messages'

    users.resources :mails, 
                    :controller => 'user/mailboxes', 
                    :member => {:reply => :post}, 
                    :collection => {:read_multiple => :put, :unread_multiple => :put, :destroy_multiple => :delete}

    users.resources :friends, 
                    :controller => 'user/friends',
                    :collection => {:search => :get}

    users.resources :visitor_records,
                    :controller => 'user/visitor_records'

    users.resources :statuses, 
                    :controller => 'user/statuses'

    users.resources :status_feeds,
                    :controller => 'user/status_feeds',
                    :collection => {:get => :get}
  
    users.resources :blogs, 
                    :controller => 'user/blogs', 
                    :member => {:confirm_destroy => :get}, 
                    :collection => {:destroy_multiple => :delete}

    users.resources :blog_feeds,
                    :controller => 'user/blog_feeds',
                    :collection => {:get => :get}

    users.resources :tagged_blogs,
                    :controller => 'user/tagged_blogs'

    users.resources :albums, 
                    :controller => 'user/albums', 
                    :member => {:confirm_destroy => :get}

    users.resources :album_feeds,
                    :controller => 'user/album_feeds',
                    :collection => {:get => :get}

    users.resources :tagged_photos,
                    :controller => 'user/tagged_photos'

    users.resources :videos,
                    :controller => 'user/videos',
                    :member => {:confirm_destroy => :get}

    users.resources :video_feeds,
                    :controller => 'user/video_feeds',
                    :collection => {:get => :get}

    users.resources :tagged_videos,
                    :controller => 'user/tagged_videos'

    users.resources :resource_feeds,
                    :controller => 'user/resource_feeds',
                    :collection => {:get => :get}
  end  

  map.resources :statuses do |statuses|
    statuses.resources :comments,
                       :controller => 'user/scomments'
  end

  map.resources :blogs do |blogs|
    blogs.resources :comments, 
                    :controller => 'user/bcomments'

    blogs.resources :tags, 
                    :controller => 'user/btags'

    blogs.resources :digs, 
                    :controller => 'user/bdigs'
  end

  map.resources :photos do |photos|
    photos.resources :comments, 
                     :controller => 'user/pcomments'

    photos.resources :tags, 
                     :controller => 'user/ptags'

    photos.resources :digs, 
                     :controller => 'user/pdigs'
  end

  map.resources :albums do |albums|
    albums.resources :photos, 
                     :controller => 'user/photos',
                     :member => {:confirm_destroy => :get, :cover => :post}, 
                     :collection => {:update_multiple => :put, :edit_multiple => :get, :create_multiple => :post}
  end

  map.resources :videos do |videos|
    videos.resources :comments,
                     :controller => 'user/vcomments'
    
    videos.resources :tags,
                     :controller => 'user/vtags'

    videos.resources :digs,
                     :controller => 'user/vdigs'
  end


  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end


