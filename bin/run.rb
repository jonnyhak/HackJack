require_relative '../config/environment'
require "tty-prompt"
require 'deck-of-cards' 


# prompt = TTY::Prompt.new

# puts prompt.yes?("Do you like Ruby?")

#puts HackJack.place_your_bet
#puts HackJack.user_cards

#puts HackJack.dealer_card


# puts "Welcome to HackJack" 

# puts "HELLO WORLD"
app = HackJack.new
app.run 

#puts HackJack.main_menu