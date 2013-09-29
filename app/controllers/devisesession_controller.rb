class DevisesessionController < Devise::SessionsController

  def create
    Rails.logger.debug(params[:user][:email])
    user = User.find_by_email(params[:user][:email])
    if(!user.nil?)
      Rails.logger.debug(user.is_approved)
      Rails.logger.debug(user.is_approved == 1)
      if(user.is_approved == 1)
        super
      else
        respond_to do| format |
          format.html { redirect_to new_user_session_path, notice: 'Unauthorized User'}
        end             
      end
    else
      respond_to do| format |
        format.html { redirect_to new_user_session_path, notice: 'Invalid username'}
      end          
    end
  end
  
end
