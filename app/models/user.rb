class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
    :first_name, :zipcode, :email, :is_approved, :user_type, :address, :city, 
    :state, :phone_no, :last_name, :company_name, :last_name, :dob, :image, 
    :linkedin, :twitter, :facebook, :description, :website, :interest, :press, :website_title, :press_title
  # attr_accessible :title, :body
  mount_uploader :image, ImageUploader
                
  validates_presence_of :email, :first_name,  :user_type,  
                          :last_name, :company_name,  :dob
                        
  validates :email, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }, :allow_blank => true
                        
  has_many :follower_relationships, class_name: "Relationship", foreign_key: "followed_id"
  has_many :followed_relationships, class_name: "Relationship", foreign_key: "follower_id"
  has_many :followers, through: :follower_relationships
  has_many :followeds, through: :followed_relationships
  has_many :ribbits

  def following? user
      self.followeds.include? user
  end

  def follow user
      Relationship.create follower_id: self.id, followed_id: user.id
  end  
end
