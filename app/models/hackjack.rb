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
           system('clear')
            self.login 
        elsif splash == "sign up"
            system('clear')
            self.signup 
        end
    end

    def self.login 
        puts "username:"
        user_username = gets.chomp 
        puts "password:"
        user_password = gets.chomp 
        @user = User.all.find_by(username: user_username, password: user_password)
        if @user 
            self.play_a_round 
        else
            puts "Invalid username or password."
            self.login 
        end
    end

    def self.signup 
        puts "username:"
        user_username = gets.chomp 
        puts "password:"
        user_password = gets.chomp
        @user = User.create(username: user_username, password: user_password)
        self.play_a_round
    end

    def main_menu
        #play a round
        #see previous games
        #see bank total
        #delete previous games
    end

    def self.play_a_round
        @dealer = Dealer.all.sample 
        @round = Round.create(user_id: @user.id, dealer_id: @dealer.id)
        puts self.place_your_bet
        sleep(2) 
        puts self.user_cards 
        sleep(3)
        puts self.dealer_card
    end

    def self.place_your_bet
        puts "Place your bet!"
        bet_amount = gets.chomp
        @round.wager = bet_amount.to_i
        if bet_amount.to_i > @user.bank
            puts "Bet must be lower than your current bank amount: #{@user.bank}!"
            self.place_your_bet
        else 
            "You bet #{bet_amount.to_i} coins on this round!"
        end
    end
    
    def self.user_cards 
        # deck = DeckOfCards.new
        # deck.shuffle
        
        # user_card_1 = deck.draw
        # user_card_2 = deck.draw
        
        # [user_card_1, user_card_2]
        #deck = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]
        
        user_card_1 = self.deck_of_cards.sample.to_s
        user_card_2 = self.deck_of_cards.sample.to_s
        puts "Your cards are the #{user_card_1} and the #{user_card_2}."
        @round.user_card_total = self.card_parser(user_card_1) + self.card_parser(user_card_2)
        # @round.user_card_total
        puts "Your total is currently #{@round.user_card_total}!"
    end
    
    def self.dealer_card
        #deck = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]
        
        dealer_card_1 = self.deck_of_cards.sample.to_s
        puts "The dealer's cards are #{dealer_card_1} and *unknown*."
        @dealer_total = self.card_parser(dealer_card_1)
        puts "The dealer's total is currently #{@dealer_total}."
    end
    
    
    
    private

    def self.deck_of_cards
        DeckOfCards.new.shuffle      
    end
     
    def self.card_parser(card)
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