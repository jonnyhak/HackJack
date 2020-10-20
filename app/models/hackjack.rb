require 'deck-of-cards'

class HackJack

    def self.place_your_bet
        puts "Place your bet!"
        bet_amount = gets.chomp
        if bet_amount.to_i > 20 
            puts "Bet must be lower than bank amount!"
            self.place_your_bet
        else 
            "You bet #{bet_amount.to_i} on this round!"
        end
    end

    def self.user_cards 
        # deck = DeckOfCards.new
        # deck.shuffle

        # user_card_1 = deck.draw
        # user_card_2 = deck.draw

        # [user_card_1, user_card_2]
        deck = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]

        user_card_1 = deck.sample
        user_card_2 = deck.sample

        total = user_card_1 + user_card_2
    end

    def self.dealer_card
        deck = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]

        dealer_card_1 = deck.sample 
    end

    def hit_or_stay


    end

    
    







end