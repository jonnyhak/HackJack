
class User < ActiveRecord::Base 
    has_many :rounds
    has_many :dealers, through: :rounds




end