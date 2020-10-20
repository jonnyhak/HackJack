require 'deck-of-cards'

class HackJack

    
    def place_your_bet
        puts "Place your bet!"
        bet_amount = gets.chomp
        if bet_amount.to_i > 20 
            puts "Bet must be lower than bank amount!"
            self.place_your_bet
        else 
            "You bet #{bet_amount.to_i} on this round!"
        end
    end
    
    def user_cards 
        # deck = DeckOfCards.new
        # deck.shuffle
        
        # user_card_1 = deck.draw
        # user_card_2 = deck.draw
        
        # [user_card_1, user_card_2]
        deck = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]
        
        user_card_1 = deck_of_cards.sample.to_s
        user_card_2 = deck_of_cards.sample.to_s
        puts "Your cards are the #{user_card_1} and the #{user_card_2}."
        total = card_parser(user_card_1) + card_parser(user_card_2)
        puts "Your total is currently #{total}!"
    end
    
    def dealer_card
        #deck = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]
        
        dealer_card_1 = deck_of_cards.sample.to_s
        puts "The dealer's cards are #{dealer_card_1} and *unknown*."
        total = card_parser(dealer_card_1)
        puts "The dealer's total is currently #{total}."
    end
    
    
    def run 
        puts place_your_bet 
        puts user_cards 
        puts dealer_card
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
        elsif card[0] == 1 && card[1] == 0
            card_amount = 10 
        else
            card_amount = card[0].to_i
        end
        card_amount  
    end
    



end #HackJack