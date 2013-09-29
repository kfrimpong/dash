class LandingController < ApplicationController
  layout "landing_layout"
  def home
    
  end

  def new_account_confirm
    respond_to do |format|
      format.html { redirect_to home_path, notice: 'Thanks! You will be notified by an admin when you are approved.' }
      format.json { head :no_content }
    end    
  end
end
