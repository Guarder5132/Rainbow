class User < ActiveRecord::Base
    before_save { email.downcase! }
    validates :name,  presence:true, length:{ maximum:20 }
    VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence:true, format: { with: VALID_EMAIL } ,uniqueness:{ case_sensitive: false }
    validates :password, length: { minimum:6 }
    has_secure_password
end
