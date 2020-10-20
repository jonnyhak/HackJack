require 'faker'

User.destroy_all

5.times do 
    User.create(username: Faker::Name.first_name, password: "alexa123")
end
