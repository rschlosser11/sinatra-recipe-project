class User < ActiveRecord::Base
  has_many :recipies
  has_many :articles
end
