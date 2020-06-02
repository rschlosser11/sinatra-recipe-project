class User < ActiveRecord::Base
  has_many :recipes
  has_many :articles
  has_secure_password
end
