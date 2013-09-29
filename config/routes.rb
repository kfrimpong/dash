Brandslip::Application.routes.draw do
  resources :relationships


  resources :ribbits


  resources :contact_us


  resources :user_job_proposals

  resources :jobs
#
#  edit_user GET    /users/:id/edit(.:format)              users#edit
#  match "/users/:id" => "brandslip#show", :as => :user
#  match "/users" => "brandslip#presenters_update", :as => :users
  devise_for :users, :controllers => {:sessions => "devisesession"}#, :confirmations => "confirmation", :registrations => "registration"}

  root :to => "brandslip#home", constraints: lambda { |r| r.env["warden"].authenticate? }, :as => :dashboard
  root :to => "landing#home", :as => :home
  
  match "new_account_confirm" => "landing#new_account_confirm", :as => :new_account_confirm
  
  match "unfollow" => "relationships#unfollow", :as => :unfollow
  match "admin_login" => "admin#admin_login", :as => :admin_login
  match "/admin/authentication" => "admin#admin_authentication", :as => :admin_authentication
  match "admin_dashboard" => "admin#admin_dashboard", :as => :admin_dashboard
  match "admin_logout" => "admin#admin_logout", :as => :admin_logout
  match "action_on_selected_user" => "admin#action_on_selected_user", :as => :action_on_selected_user
  
  match "search_job" => "brandslip#search_job", :as => :search_job
  match "search_job_filter" => "brandslip#search_job_filter", :as => :search_job_filter
  match "search_job_filter_by_location" => "brandslip#search_job_filter_by_location", :as => :search_job_filter_by_location
  match "search_job_filter_by_valid_for" => "brandslip#search_job_filter_by_valid_for", :as => :search_job_filter_by_valid_for
  match "/user_job_detail/:id" => "brandslip#user_job_detail", :as => :user_job_detail
  match "/job_detail/:id" => "brandslip#job_detail", :as => :job_detail

  match "brands_profile" => "profile#brands_profile", :as => :brands_profile
  match "presenters_profile" => "profile#presenters_profile", :as => :presenters_profile
  match "search_profile_filter" => "profile#search_profile_filter", :as => :search_profile_filter
  match "search_brand_filter" => "profile#search_brand_filter", :as => :search_brand_filter
  
  match "send_message" => "brandslip#send_message", :as => :send_message
  match "presenter_profile" => "brandslip#presenter_profile", :as => :presenter_profile
  match "brand_profile" => "brandslip#brand_profile", :as => :brand_profile
  match "presenters_profile_edit" => "brandslip#presenters_profile_edit", :as => :presenters_profile_edit
  match "brands_profile_edit" => "brandslip#brands_profile_edit", :as => :brands_profile_edit
  match "delete_messages" => "brandslip#delete_messages", :as => :delete_messages
  match "presenters_profile_show" => "brandslip#presenters_profile_show", :as => :presenters_profile_show
  match "brands_profile_show" => "brandslip#brands_profile_show", :as => :brands_profile_show  
  match "edit_profile" => "brandslip#edit_profile", :as => :edit_profile1
  match "save_user" => "brandslip#save_user", :as => :save_user
  match "delete_job_proposal" => "brandslip#delete_job_proposal", :as => :delete_job_proposal
  match "edit_job_proposal" => "brandslip#edit_job_proposal", :as => :edit_job_proposal
  match "followings_users" => "brandslip#followings_users", :as => :followings_users
  match "followers_users" => "brandslip#followers_users", :as => :followers_users
  match "add_newsfeed" => "brandslip#add_newsfeed", :as => :add_newsfeed
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
