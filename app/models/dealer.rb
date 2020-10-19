
class Dealer < ActiveRecord::Base
    has_many :rounds
    has_many :users, through: :rounds 

end