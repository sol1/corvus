class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_many :comments
  has_many :ratings
  belongs_to :team
  
  def shortname
  	self.email # FIXME
  end
end
