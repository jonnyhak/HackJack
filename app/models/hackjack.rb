require 'deck-of-cards'
require 'tty-prompt'
require 'pry'

class HackJack

    def run 
        self.class.main_menu 
    end

    #MAIN MENU ---------------------------------------------------------    

    def self.main_menu
        puts "Welcome to"
        a = Artii::Base.new 
        puts a.asciify('HackJack!')
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

    #---------------------------------------------------------------------------

    #LOGIN MAIN MENU -----------------------------------------------------------

    def self.login_main_menu
        prompt = TTY::Prompt.new 
        splash = prompt.select("Login Main Menu") do |prompt| 
            prompt.choice "Play a round"
            prompt.choice "See bank total"
            prompt.choice "See previous rounds"
            prompt.choice "Delete previous rounds"
            prompt.choice "Logout"
        end

        case splash
            when "Play a round"
                self.play_a_round 
            when "See bank total"
                self.see_bank_total
            when "See previous rounds"
                self.previous_rounds
            when "Delete previous rounds"
                self.delete_previous_rounds
            when "Logout"
                system('clear')
                self.main_menu
        end
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

    def self.see_bank_total
        puts "Your current bank amount is #{@user.bank} coins."
        sleep(3)
        self.back_to_main_menu
    end

    def self.previous_rounds 
        @user_rounds = Round.where(user_id: @user.id)
        @user_rounds.each_with_index do |round, index|
            puts "#{index + 1}." 
            puts "Dealer name: #{round.dealer.name}"
            puts "Your total: #{round.user_card_total}"
            puts "Dealer total: #{round.dealer_card_total}"
            puts "Bet amount: #{round.wager}"
            
        end
            
        self.back_to_main_menu 
    end


    def self.delete_previous_rounds 
        prompt = TTY::Prompt.new 
        splash = prompt.select("Would you like to delete all outcomes?") do |prompt| 
            prompt.choice "Yes"
            prompt.choice "No"
        end
        if splash == "Yes"
            @user_rounds.destroy_all
            @user.update(bank: 20)
            puts "All rounds have been deleted."
            sleep(2)
            puts "Your bank amount has been set to 20"
            sleep(2)
            self.back_to_main_menu
        elsif splash == "No"
            self.back_to_main_menu 
        end
    end

    def self.back_to_main_menu
        prompt = TTY::Prompt.new
        splash = prompt.select("Go Back") do |prompt|
            prompt.choice "Back to Main Menu"
        end
        if splash == "Back to Main Menu"
            system('clear')
            self.login_main_menu
        end
    end
    #--------------------------------------------------------------------

    #PLAY A ROUND -------------------------------------------------------

    

    def self.place_your_bet
        if @user.bank == 0
            puts "Insufficient funds"
            sleep(2)
            self.back_to_main_menu
        else
            puts "Your current bank amount is #{@user.bank} coins."
            sleep(2)
            puts "Place your bet!"
            
            #helper method?
            bet_amount = gets.chomp
            @round.update(wager: bet_amount.to_i)

            if bet_amount.to_i > @user.bank
                puts "Bet must be lower than your current bank amount: #{@user.bank}!"
                self.place_your_bet
            elsif bet_amount.to_i < 1
                puts "Must place a bet greater than 0"
                sleep(2)
                self.place_your_bet
            else 
                "You bet #{bet_amount.to_i} coins on this round!"
            end
        end
    end
    
    def self.user_cards 
        user_card_1 = self.deck_of_cards.sample.to_s
        user_card_2 = self.deck_of_cards.sample.to_s
        @user_total = self.card_parser(user_card_1) + self.card_parser(user_card_2)
        puts "Your cards are the #{user_card_1} and the #{user_card_2}."
        
        @round.update(user_card_total: @user_total)
        sleep(2)
        puts "Your total is currently #{@round.user_card_total}!"
    end
    
    def self.dealer_card
        @dealer_card_1 = self.deck_of_cards.sample.to_s
        @dealer_total = self.card_parser(@dealer_card_1) 
        puts "The dealer's cards are #{@dealer_card_1} and *unknown*."
        @round.update(dealer_card_total: @dealer_total)
        sleep(2)
        puts "The dealer currently shows a #{@dealer_card_1.split[0]}."
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
        sleep(2) 
        next_card = self.deck_of_cards.sample.to_s
        puts "Next card is #{next_card}"
        @round.update(user_card_total: @user_total += self.card_parser(next_card))
        sleep(2)
        puts "Your total is currently #{@round.user_card_total}!"
        if @round.user_card_total <= 21
            sleep(2)
            self.hit_or_stay
        else
            sleep(2)
            puts "Over 21! Bust!"
            bank_total = @user.bank
            @user.update(bank: bank_total - @round.wager)
            sleep(2)
            puts "Your bank total is now #{@user.bank}"
            self.back_to_main_menu
        end
    end

    def self.stay
        sleep(2) 
        dealer_card_2 = self.deck_of_cards.sample.to_s
        puts "The dealer's flipped card is #{dealer_card_2}."
        @round.update(dealer_card_total: @dealer_total += self.card_parser(dealer_card_2))
        sleep(2)
        puts "The dealer's total is currently #{@round.dealer_card_total}."

        #dealer_turn helper method
        if @round.dealer_card_total < 17
            sleep(2)
            self.stay
        elsif @round.dealer_card_total > 21
            sleep(2)
            puts "Dealer Busts!"
            bank_total = @user.bank
            @user.update(bank: bank_total + @round.wager)
            sleep(2)
            puts "Your bank total is now #{@user.bank}"
        else
            #comparing_totals helper method (who wins round?)
            if @round.dealer_card_total == @round.user_card_total
                sleep(2)
                puts "Push!"
            elsif @round.dealer_card_total > @round.user_card_total
                sleep(2)
                puts "Dealer wins round :("
                bank_total = @user.bank
                @user.update(bank: bank_total - @round.wager)
                sleep(2)
                puts "Your bank total is now #{@user.bank}"
            else
                sleep(2)
                puts "User wins round :)"
                bank_total = @user.bank
                @user.update(bank: bank_total + @round.wager)
                sleep(2)
                puts "Your bank total is now #{@user.bank}"
            end
        end
        #call self.play_another_round? instead
        sleep(2)
        self.back_to_main_menu
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
               self.back_to_main_menu 
            end
        elsif splash == "No"
            puts "See you next time"
            self.back_to_main_menu 
        end
    end

    #-------------------------------------------------------------------

    

    private

    #CARDS #-------------------------------------------------------------------

    def self.deck_of_cards
        DeckOfCards.new.shuffle      
    end
    

    def self.card_parser(card)
        #jack or queen or king all on one line
        card_amount = 0
        if card.include?("Jack")
            card_amount = 10
        elsif card.include?("Queen")
            card_amount = 10
        elsif card.include?("King")
            card_amount = 10 
        elsif card.include?("Ace")
            card_amount = 1
            #when to pick 1 or 11
        elsif card.include?("10")
            card_amount = 10 
        else
            card_amount = card[0].to_i
        end
        card_amount  
    end
    
    #---------------------------------------------------------------------
    
end #HackJack
# binding.pry 





