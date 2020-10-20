require 'deck-of-cards'
require 'tty-prompt'

class HackJack

    def run 
        #welcome
        #login or sign up
        self.class.main_menu 
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
            self.login_main_menu 
        else
            puts "Invalid username or password."
            sleep(2)
            self.main_menu  
        end
    end

    def self.signup 
        puts "username:"
        user_username = gets.chomp 
        puts "password:"
        user_password = gets.chomp
        @user = User.create(username: user_username, password: user_password)
        self.login_main_menu
    end

    def self.login_main_menu
        prompt = TTY::Prompt.new 
        splash = prompt.select("Login Main Menu") do |prompt| 
            prompt.choice "Play a round"
            prompt.choice "See bank total"
            prompt.choice "Logout"

        end
        if splash == "Play a round"
            self.play_a_round 
        elsif splash == "See bank total"
            puts "Your current bank amount is #{@user.bank} coins."
            sleep(3)
            self.login_main_menu
        elsif splash == "Logout"
            system('clear')
            self.main_menu
        end
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
        sleep (2)
        puts self.hit_or_stay
    end

    def self.place_your_bet
        puts "Your current bank amount is #{@user.bank} coins."
        puts "Place your bet!"
        bet_amount = gets.chomp

        #@round.wager = bet_amount.to_i
        @round.update(wager: bet_amount.to_i)
        if bet_amount.to_i > @user.bank
            puts "Bet must be lower than your current bank amount: #{@user.bank}!"
            self.place_your_bet
        else 
            "You bet #{bet_amount.to_i} coins on this round!"
        end
    end
    
    def self.user_cards 
        user_card_1 = self.deck_of_cards.sample.to_s
        user_card_2 = self.deck_of_cards.sample.to_s
        @user_total = self.card_parser(user_card_1) + self.card_parser(user_card_2)
        puts "Your cards are the #{user_card_1} and the #{user_card_2}."
        
        @round.update(user_card_total: @user_total)
        # @round.user_card_total
        puts "Your total is currently #{@round.user_card_total}!"
    end
    
    def self.dealer_card
        @dealer_card_1 = self.deck_of_cards.sample.to_s
        @dealer_total = self.card_parser(@dealer_card_1) 
        puts "The dealer's cards are #{@dealer_card_1} and *unknown*."
        @round.update(dealer_card_total: @dealer_total)
        # @dealer_total.update = self.card_parser(dealer_card_1)
        puts "The dealer's total is currently #{@round.dealer_card_total}."
    end

    def self.hit_or_stay 
        prompt = TTY::Prompt.new 
        splash = prompt.select("Hit or Stay?") do |prompt| 
            prompt.choice "Hit"
            prompt.choice "Stay"
        end
        if splash == "Hit"
            self.hit 
        elsif splash == "Stay"
            self.stay 
        end
    end

    def self.hit 
        next_card = self.deck_of_cards.sample.to_s
        puts "Next card is #{next_card}"
        @round.update(user_card_total: @user_total += self.card_parser(next_card))
        puts "Your total is currently #{@round.user_card_total}!"
        if @round.user_card_total <= 21
            self.hit_or_stay
        else
            puts "Over 21! Bust!"
            bank_total = @user.bank
            @user.update(bank: bank_total - @round.wager)
            puts "Your bank total is now #{@user.bank}"
        end
    end

    def self.stay 
        dealer_card_2 = self.deck_of_cards.sample.to_s
        puts "The dealer's card is #{dealer_card_2}."
        @round.update(dealer_card_total: @dealer_total += self.card_parser(dealer_card_2))
        puts "The dealer's total is currently #{@round.dealer_card_total}."

        if @round.dealer_card_total < 17
            # dealer_new_card = self.deck_of_cards.sample.to_s
            # puts "Next card is #{dealer_new_card}"
            # @round.update(dealer_card_total: @dealer_total += self.card_parser(dealer_new_card))
            # puts "The dealer's total is currently #{@round.dealer_card_total}."
            sleep(5)
            self.stay
        elsif @round.dealer_card_total > 21
            puts "Dealer Busts!"
            bank_total = @user.bank
            @user.update(bank: bank_total + @round.wager)
            puts "Your bank total is now #{@user.bank}"
        else
            if @round.dealer_card_total == @round.user_card_total
                puts "Push!"
            elsif @round.dealer_card_total > @round.user_card_total
                puts "Dealer wins round :("
                bank_total = @user.bank
                @user.update(bank: bank_total - @round.wager)
                puts "Your bank total is now #{@user.bank}"
            else
                puts "User wins round :)"
                bank_total = @user.bank
                @user.update(bank: bank_total + @round.wager)
                puts "Your bank total is now #{@user.bank}"
            end
        end
        play_another_round?
    end

    def self.play_another_round?
        prompt = TTY::Prompt.new 
        splash = prompt.select("Play another round?") do |prompt| 
            prompt.choice "Yes!"
            prompt.choice "No"
        end
        if splash == "Yes!"
            if @user.bank > 0
                self.play_a_round
            else
               puts "You are out of coins :("
               self.login_main_menu 
            end
        elsif splash == "No"
            puts "See you next time"
            self.login_main_menu 
        end
    
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