require 'deck-of-cards'
require 'tty-prompt'

class HackJack

    def run 
        #welcome
        self.class.main_menu 
        #login or sign up
        #main menu
        #if pick play a round:
        #play_a_round
    end
    
    def self.main_menu 
        prompt = TTY::Prompt.new 
        splash = prompt.select("Please log in or sign up!") do |prompt| 
            prompt.choice "log in"
            prompt.choice "sign up"
        end
        if splash == "log in"
            login 
        elsif splash == "sign up"
            sign up 
        end
    end

    def login 

    end

    def signup 

    end

    def main_menu
        #play a round
        #see previous games
        #see bank total
        #delete previous games
    end

    def play_a_round
        #@round = Round.create(user_id: , dealer_id: )
        puts place_your_bet
        sleep(2) 
        puts user_cards 
        sleep(3)
        puts dealer_card
    end
    def place_your_bet
        puts "Place your bet!"
        bet_amount = gets.chomp
        if bet_amount.to_i > 20 
            puts "Bet must be lower than your current bank amount!"
            self.place_your_bet
        else 
            "You bet #{bet_amount.to_i} coins on this round!"
           # @round = Round.create(wager: bet_amount.to_i)
        end
    end
    
    def user_cards 
        # deck = DeckOfCards.new
        # deck.shuffle
        
        # user_card_1 = deck.draw
        # user_card_2 = deck.draw
        
        # [user_card_1, user_card_2]
        #deck = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]
        
        user_card_1 = deck_of_cards.sample.to_s
        user_card_2 = deck_of_cards.sample.to_s
        puts "Your cards are the #{user_card_1} and the #{user_card_2}."
        @round.user_card_total = card_parser(user_card_1) + card_parser(user_card_2)
        # @round.user_card_total
        puts "Your total is currently #{@round.user_card_total}!"
    end
    
    def dealer_card
        #deck = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]
        
        dealer_card_1 = deck_of_cards.sample.to_s
        puts "The dealer's cards are #{dealer_card_1} and *unknown*."
        @dealer_total = card_parser(dealer_card_1)
        puts "The dealer's total is currently #{@dealer_total}."
    end
    
    
    
    private

    def deck_of_cards
        DeckOfCards.new.shuffle      
    end
     
    def card_parser(card)
        card_amount = 0
        if card.include?("Jack")
            card_amount = 10
        elsif card.include?("Queen")
            card_amount = 10
        elsif card.include?("King")
            card_amount = 10 
        elsif card.include?("Ace")
            card_amount = 11
            #when to pick 1 or 11
        elsif card[0] == 1 && card[1] == 0
            card_amount = 10 
        else
            card_amount = card[0].to_i
        end
        card_amount  
    end
    



end #HackJack