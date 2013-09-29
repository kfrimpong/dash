
class BrandslipController < ApplicationController
  layout 'brandslip_layout'
  before_filter :is_profile_complete, :except => [:edit_profile, :save_user]
  
  def home
    @user_jobs = Job.where(:job_user_id => current_user.id)
    @user_proposals = Job.find_by_sql("select j.id id, ujp.job_id, ujp.id proposal_id,
                                              j.job_title job_title,
                                              ujp.proposal_details, j.job_user_id 
                                              from jobs j, user_job_proposals ujp 
                                              where j.id=ujp.job_id and ujp.user_id=#{current_user.id}")
#    proposals = UserJobProposal.where(:user_id => current_user.id)
#    if(!proposals.nil? && !proposals[0].nil?)
#      job_id = []
#      proposals.each do |proposal|
#        job_id.push(proposal.job_id)
#      end
#      @user_proposals = Job.find_by_sql("select * from jobs where id in (#{job_id.join(',')})")
#    else
#      @user_proposals = []
#    end
    
    @inbox = UserMessage.where(:to_user => current_user.id)
    @inbox.each do |msg|
      user = User.find(msg.from_user)
      if !user.nil?
        msg[:from] = user.email
        msg[:first_name] = user.first_name
        msg[:last_name] = user.last_name
        msg[:company_name] = user.company_name
        msg[:user_interest_id] = user.interest
      else
        msg[:from] = "--"
        msg[:first_name] = "--"
        msg[:last_name] = "--"
        msg[:company_name] = "--"
        msg[:user_interest_id] = "--"
      end
    end
    @sent_msg = UserMessage.where(:from_user => current_user.id)
    @sent_msg.each do |msg|
      user = User.find(msg.to_user)
      if !user.nil?
        msg[:to] = user.email
        msg[:first_name] = user.first_name
        msg[:last_name] = user.last_name
        msg[:company_name] = user.company_name        
      else
        msg[:to] = "--"
        msg[:first_name] = "--"
        msg[:last_name] = "--"
        msg[:company_name] = "--"        
      end
    end
    buddies_ids = current_user.followeds.map(&:id)
    @ribbits = Ribbit.find_all_by_user_id buddies_ids 
    @contact_u = ContactU.new
  end
  
  def search_job
    Rails.logger.debug("=============#{current_user.nil?}")
    if(current_user.nil?)
      redirect_to home_url
      return
    end
    if(params[:title].present? && !params[:title].nil?)
      @jobs = Job.find_by_sql("select * from jobs where DATE_ADD(created_at, INTERVAL job_valid_for day)>now() and job_user_id not in (#{current_user.id}) and job_title like '%#{params[:title]}%' order by id desc")
    else
      @jobs = Job.find_by_sql("select * from jobs where DATE_ADD(created_at, INTERVAL job_valid_for day)>now() and job_user_id not in (#{current_user.id}) order by id desc")
    end
  end  
  
  def search_job_filter
    Rails.logger.debug("#{current_user.nil?}")
    Rails.logger.debug(params[:category_arr])
    Rails.logger.debug(params[:crowd_size_arr])
    Rails.logger.debug(params[:category_arr].include? "-1")
    crowd_size_clause = ""
    if(params[:crowd_size_arr].include? "-1")
      crowd_size_clause = ""
    else
      crowd_size_clause += "and ("
      crowd_size_length = params[:crowd_size_arr].length
      index = 0
      params[:crowd_size_arr].each do |crowd_size|
        if((index + 1) == crowd_size_length)
          crowd_size_clause += " crowd_size='#{crowd_size}' "
        else
          crowd_size_clause += " crowd_size='#{crowd_size}' or "
        end
        index = index + 1
      end
      crowd_size_clause += ") "
    end
    if(params[:category_arr].include? "-1")
      @jobs = Job.find_by_sql("select * from jobs where DATE_ADD(created_at, INTERVAL job_valid_for day)>now() and job_user_id not in (#{params[:job_user_id]}) #{crowd_size_clause} order by id desc")
    else
      category_str = params[:category_arr].join(",")
      @jobs = Job.find_by_sql("select * from jobs where DATE_ADD(created_at, INTERVAL job_valid_for day)>now() and job_user_id not in (#{params[:job_user_id]}) #{crowd_size_clause} and job_category in (#{category_str}) order by id desc")
    end
    render :template => "brandslip/_all_jobs", :layout => false
  end
  
  def search_job_filter_by_location
    @jobs = Job.find_by_sql("select * from jobs where DATE_ADD(created_at, INTERVAL job_valid_for day)>now() and job_user_id not in (#{params[:job_user_id]}) and state='#{params[:state]}' and city='#{params[:city]}' order by id desc")
    render :template => "brandslip/_all_jobs", :layout => false
  end
  
  def search_job_filter_by_valid_for
    if(params[:valid_for] == 'newly_posted')
      @jobs = Job.find_by_sql("select * from jobs where DATE_ADD(created_at, INTERVAL job_valid_for day)>now() and job_user_id not in (#{params[:job_user_id]})  order by job_valid_for - DATEDIFF(now() , created_at) desc")
    else
      @jobs = Job.find_by_sql("select * from jobs where DATE_ADD(created_at, INTERVAL job_valid_for day)>now() and job_user_id not in (#{params[:job_user_id]})  order by job_valid_for - DATEDIFF(now() , created_at)")
    end
    
    render :template => "brandslip/_all_jobs", :layout => false
  end
  
  def user_job_detail
      @job_details = Job.where(:id => params[:id])
      @users_applied_for_job = UserJobProposal.where(:job_id => params[:id]).order("id desc")
      @users_applied_for_job.each do |proposal|
        proposal["user_name"] = User.where(:id => proposal.user_id)[0]['full_name']
      end      
  end
  
  def job_detail
      @job_details = Job.where(:id => params[:id])
      @user_job_proposal = UserJobProposal.new
      @users_applied_for_job = UserJobProposal.where(:job_id => params[:id]).order("id desc")
      @users_applied_for_job.each do |proposal|
        proposal["user_name"] = User.where(:id => proposal.user_id)[0]['full_name']
      end
  end  
  
  def send_message
    Rails.logger.debug(params[:from_user_id])
    Rails.logger.debug(params[:to_user_id])
    Rails.logger.debug(params[:message_title])
    Rails.logger.debug(params[:message_body])
    from_user = User.find(params[:from_user_id])
    to_user = User.find(params[:to_user_id])
    um = UserMessage.new(:from_user => params[:from_user_id], :to_user => params[:to_user_id],
                          :message_title => params[:message_title], 
                          :message_body => params[:message_body])
    um.save     
    if(!to_user.nil?)
      UserMailer.message_notifier(params[:message_title], params[:message_body], from_user, to_user).deliver
    end
    render :json => {}
  end
  
  def brand_profile
    if(params[:full_name].present? && !params[:full_name].nil?)
     @brands = User.find_by_sql("select * from users where user_type = 1 and (first_name like '%#{params[:full_name]}%' or last_name like '%#{params[:full_name]}%') order by id desc")
    else
      @brands = User.find_by_sql("select * from users where user_type = 1  order by id desc")
    end
    @relationship = Relationship.new    
  end
  
  def presenter_profile
    if(params[:full_name].present? && !params[:full_name].nil?)
     @presenters = User.find_by_sql("select * from users where user_type = 2 and (first_name like '%#{params[:full_name]}%' or last_name like '%#{params[:full_name]}%') order by id desc")
    else
      @presenters = User.find_by_sql("select * from users where user_type = 2  order by id desc")
    end
    @relationship = Relationship.new    
  end
  
  def presenters_profile_edit
    @presenters_profile_edit = User.find(params[:id])
  end
  
def presenters_update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "presenters_profile_edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def brands_profile_edit
    @brands_profile_edit = User.find(params[:id])
  end
  
  def delete_messages
    Rails.logger.debug(params[:delete_message_id])
    UserMessage.delete_all("id=#{params[:delete_message_id]}")
    render :json => {}
  end
  
  def edit_profile
    @users = User.find(current_user.id) 
  end
  
  def view_profile
    @users = User.find(current_user.id) 
  end
  
  def save_user
    @user = User.find(current_user.id) 
    Rails.logger.debug params
    @user.update_attributes(params[:user])
    @user.is_processed = 1
    @user.save
    session[:is_complete_profile] = nil
    render :json => {}    
  end

 def presenters_profile_show
  @user = User.find(params[:id])
  @relationship = Relationship.new
 end
 
 def brands_profile_show
  @user = User.find(params[:id])
  @relationship = Relationship.new
 end
 
 def delete_job_proposal
   Rails.logger.debug("#{params[:proposal_id]}")
   UserJobProposal.delete_all("id=#{params[:proposal_id]}")
   render :json => {}
 end
 
 def edit_job_proposal
   
 end
 
 def followings_users
   @followings = current_user.followeds
 end
 
 def followers_users
   @followers = current_user.followers
 end
 
 def add_newsfeed
   ribbit = Ribbit.new(:user_id => current_user.id, :content => params[:newsfeed_desc])
   ribbit.save
   render :json => {}
 end
 
end
