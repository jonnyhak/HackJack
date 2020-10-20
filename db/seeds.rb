require 'faker'

User.destroy_all
Dealer.destroy_all 

5.times do 
    User.create(username: Faker::Name.first_name, password: "alexa123")
end

 
[Dealer.create(name: "Dealer 1"),
Dealer.create(name: "Dealer 2"),
Dealer.create(name: "Dealer 3"),
Dealer.create(name: "Dealer 4"),
Dealer.create(name: "Dealer 5")]


