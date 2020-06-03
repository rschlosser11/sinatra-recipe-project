class User < ActiveRecord::Base
  validates :email, format: { with: /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}\b/ }, uniqueness: true
  validates :username, :password, presence: true
  has_many :recipes
  has_many :articles
  has_secure_password
end
