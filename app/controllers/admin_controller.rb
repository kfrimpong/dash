class AdminController < ApplicationController
#  before_filter :authenticate, :except => [:admin_login, :admin_authentication]
  layout "admin_layout"
  
  def authenticate
    if session[:admin].nil?
      #unauthorized access
      Rails.logger.debug("Session expired.......")
      redirect_to admin_login_path
    end
  end
  
  def admin_login
    
  end
  
  def admin_authentication
    if(params[:admin_email] == 'kofi@gmail.com' && params[:admin_password] == "kofi123")
      session[:admin] = '1'
      redirect_to admin_dashboard_path
    else
      respond_to do| format |
        format.html { redirect_to admin_login_path, notice: 'Invalid username or Password'}
      end      
    end
    
  end
  
  def admin_dashboard
    @users = User.all
  end
  
  def admin_logout
    session[:admin] = nil
    redirect_to admin_login_path
  end
  
  def action_on_selected_user
    Rails.logger.debug(params[:user_id])
    Rails.logger.debug(params[:is_approved])
    
    params[:user_id].each do |user_id|
      Rails.logger.debug("-----------------------")
      Rails.logger.debug(user_id)
      user = User.find(user_id)
      if !user.nil?
        action = ""
        if params[:is_approved]== '1' || params[:is_approved] == 1
          if !user.confirmed?
            user.confirm!
          end
          action = "Approved"
          full_name = "#{user.first_name} #{user.last_name}"
          UserMailer.approve_notification(user.email,full_name, action).deliver
        end
        User.update_all({:is_approved => params[:is_approved]}, {:id => user_id})
      end
      
    end
    render :json => {}
    
  end
end
