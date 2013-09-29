class UserMailer < ActionMailer::Base
  def notifier(user_name, user_email, job_title)
    @user_name = user_name
    @job_title = job_title
     mail(:to => user_email, :from => "Brandslip <brandslip@gmail.com>", :subject => "Brandslip job created")
  end

  def proposal_notifier(job_user_name, proposal_user_name, job_user_email, job_details, proposal_details)
    @job_user_name = job_user_name
    @proposal_user_name = proposal_user_name
    @job_details = job_details
    @proposal_details = proposal_details
     mail(:to => job_user_email, :from => "Brandslip <brandslip@gmail.com>", :subject => "Brandslip proposal created")
  end

  def approve_notification(email, user_name, action)
    @user_name = user_name
    @action = action
    mail(:to => email, :from => "Brandslip <brandslip@gmail.com>", :subject => "Brandslip Admin Approval")
  end

  def contact_us_notifier(contact_us_detail)
    @contact_us = contact_us_detail
    mail(:to => @contact_us['email'], :from => "Brandslip <brandslip@gmail.com>", :bcc => "jaydhomse@gmail.com", :subject => "BrandSlip Contact Us")
  end
  
  def message_notifier(msg_title, msg_body, from_user, to_user)
    @msg_title = msg_title
    @msg_body = msg_body
    @from_user = "#{from_user.first_name} #{from_user.last_name}"
    @to_user = "#{to_user.first_name} #{to_user.last_name}"
    mail(:to => to_user.email, :from => "Brandslip <brandslip@gmail.com>", :bcc => "kofi@gmail.com", :subject => "BrandSlip Message: #{msg_title}")
  end  
end
