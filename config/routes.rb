ActionController::Routing::Routes.draw do |map|

  map.resources :pages

  map.resources :sessions

  map.resources :statuses

  map.resources :wall_messages

  map.resources :mails

  map.resources :icons

  map.resources :ptags

  map.resources :pdigs

  map.resources :pcomments

  map.resources :bdigs

  map.resources :friendships

  map.resources :game_characters, :collection => {:edit_new => :get}

  map.resources :game_races

  map.resources :game_professions

  map.resources :game_servers

  map.resources :game_areas

  map.resources :games

  map.root :controller => 'sessions', :action => 'new'

  map.signup '/signup', :controller => 'users', :action => 'new'

  map.login '/login', :controller => 'sessions', :action => 'new'

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'

  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  
  map.reset_password '/reset_password/:password_reset_code', :controller => 'passwords', :action => 'edit'

  map.change_password '/change_password', :controller => 'accounts', :action => 'edit'


  map.resources :users, :member => {:enable => :put} do |users|
    users.resources :characters,
                    :controller => 'user_characters',
                    :member => {:confirm_destroy => :get}

    users.resources :wall_messages, 
                    :controller => 'user_wall_messages'

    users.resources :mails, 
                    :controller => 'mailboxes', 
                    :member => {:reply => :post}, 
                    :collection => {:read_multiple => :put, :unread_multiple => :put, :destroy_multiple => :delete}

    users.resources :friends, 
                    :collection => {:search => :get}

    users.resources :statuses, 
                    :controller => 'user_statuses'

    users.resources :blogs, 
                    :controller => 'user_blogs', 
                    :member => {:confirm_destroy => :get}, 
                    :collection => {:destroy_multiple => :delete}

    users.resources :blog_feeds

    users.resources :tagged_blogs

    users.resources :albums, 
                    :controller => 'user_albums', 
                    :member => {:confirm_destroy => :get}

    users.resources :album_feeds

    users.resources :tagged_photos

    users.resource :profile

    users.resource :basic_info,
                   :controller => 'basic_info'

    users.resource :contact_info,
                   :controller => 'contact_info'
  end  

  map.resources :blogs do |blogs|
    blogs.resources :comments, 
                    :controller => 'blog_comments'

    blogs.resources :tags, 
                    :controller => 'blog_tags'

    blogs.resources :digs, 
                    :controller => 'blog_digs'
  end

  map.resources :photos do |photos|
    photos.resources :comments, 
                     :controller => 'photo_comments'

    photos.resources :tags, 
                     :controller => 'photo_tags'

    photos.resources :digs, 
                     :controller => 'photo_digs'
  end

  map.resources :albums do |albums|
    albums.resources :photos, 
                     :controller => 'album_photos',
                     :member => {:confirm_destroy => :get, :cover => :post}, 
                     :collection => {:update_multiple => :put, :edit_multiple => :get, :create_multiple => :post}
  end


  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end


