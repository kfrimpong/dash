class ProfileController < ApplicationController
layout 'admin_layout'
  def brands_profile
    @brands_users = User.where(:user_type => 1)
  end
  
  def presenters_profile
    @presenters_users = User.where(:user_type => 2)
  end
  
  def search_profile_filter
    if(params[:category_arr].include? "-1")
      @presenters = User.where(:user_type => 2)
    else
      category_str = params[:category_arr].join(",")
      @presenters = User.find_by_sql("select * from users where user_type=2 and interest in (#{category_str})")
    end
    render :template => "brandslip/_presenter_profile", :layout => false
  end
  
  def search_brand_filter
    if(params[:category_arr].include? "-1")
      @presenters = User.where(:user_type => 1)
    else
      category_str = params[:category_arr].join(",")
      @presenters = User.find_by_sql("select * from users where user_type=1 and interest in (#{category_str})")
    end
    render :template => "brandslip/_presenter_profile", :layout => false
  end
  
end
