require 'rubygems'
require 'pry'



class Card
  attr_accessor :suit, :face_value

	def initialize(suit, face_value)
		@suit = suit
		@face_value = face_value
	end

	def pretty_output 
		 "The #{face_value} of #{find_suit}"
	end

	def to_s
		pretty_output
	end

	def find_suit
		case suit
		 when 'H' then 'Hearts'
		 when 'D' then 'Diamond'
		 when 'C' then 'Clubs'
		 when 'S' then 'Spades'
	  end
  end
end 

class Deck

	attr_accessor :cards

	def initialize
		@cards = []
		['H','D','C','S'].each do |suite|
			['2','3','4','5','6','7','8','9','10','J','Q','K','A'].each do |face_value|
				@cards << Card.new(suite, face_value)
		end
	end
	scramble
end

  def scramble
  	cards.shuffle!
	end

	def deal_one
		cards.pop
	end

	def size
		cards.size
	end
end
module Hand

	def show_hand
		puts "#{name} hand's"
		cards.each do |card|
			puts "-> #{card}"
		end
		puts "-> #{total}"
	end

	def total 
		face_values = cards.map{ |card| card.face_value}

		total = 0
		face_values.each do |val|
			if val == 'A'
				total += 11
			else
				total +=(val.to_i == 0 ? 10 : val.to_i)
			end
		end
		#correction for Aces 
		face_values.select{|val| val == 'A'}.count.times do
			break if total <= Blackjack::BLACKJACK_AMOUNT
			total -= 10
		end
		total
	end
	def add_card(new_card)
		cards << new_card
  end

  def is_busted
  	total > Blackjack::BLACKJACK_AMOUNT
  end
end

class Player 
	include Hand

	attr_accessor :name, :cards

	def initialize(name)
		@name = name
		@cards = []
	end

	def show_flop

		show_hand
		puts ""
	end
end

class Dealer 
	include Hand

	attr_accessor :name, :cards

	def initialize
		@name = 'Dealer'
		@cards = []
  end

  def show_flop
  	puts ""
    puts "-- Dealers Hand --"
    puts "First card is hidden "
    puts "Second card is #{cards[1]}"
    puts ""
  end
end

class Blackjack

	attr_accessor :deck, :player , :dealer
  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MINIMUM = 17 

	def initialize
		@deck = Deck.new
		@player = Player.new('player')
		@dealer = Dealer.new
	end

	def set_player_name
		puts "Whats your name ?"
		player.name = gets.chomp
	end

	def deal_cards
		player.add_card(deck.deal_one)
		dealer.add_card(deck.deal_one)
		player.add_card(deck.deal_one)
		dealer.add_card(deck.deal_one)
	end

	def show_flop
		player.show_flop
		dealer.show_flop
	end

	def blackjack_or_bust?(player_or_dealer)
		if player_or_dealer.total == BLACKJACK_AMOUNT
			if player_or_dealer.is_a?(Dealer)
				puts "Sorry Dealer hit blackjack! You lose !!"
			else
				puts "Congratiolations you hit blackjack !"
			end

			play_again


		elsif player_or_dealer.is_busted
			if player_or_dealer.is_a?(Dealer)
				puts "Dealer busted ! congratiolations you win "
			else
				puts "sorry you're busted"
			end 
			exit 
		end
  end

	def player_turn
		puts "#{player.name}'s turn!"
    
    blackjack_or_bust?(player)
		while !player.is_busted
			puts "What would you like to do 1) hit or 2) stay"
      responce = gets.chomp
      if !['1','2'].include?(responce)
      	puts "ERROR: you must enter 1 or 2 "
      	next
      end

      	if responce == '2'
      		puts "#{player.name} you chose to stay"
      		break
      	end
        new_card = deck.deal_one
      	puts "Dealing new card to #{player.name}: #{new_card}"
      	player.add_card(new_card)
      	puts "#{player.name}'s total is :#{player.total}"

      	blackjack_or_bust?(player)
      end
      puts "#{player.name} stays at #{player.total}"
    end

    def dealer_turn
    	puts "Dealer's turn! "
    	blackjack_or_bust?(dealer)
    	while dealer.total < DEALER_HIT_MINIMUM
    		new_card = deck.deal_one
    		puts "Dealing new card to Dealer : #{new_card}"
    		dealer.add_card(new_card)
    		puts "Dealer total is now :#{dealer.total}"


      blackjack_or_bust?(dealer)
    	end
    	puts "dealer stays at #{dealer.total}"
    end

    def who_won?
    	if player.total > dealer.total 
    		puts "#{player.name} you win"
    	elsif player.total == dealer.total 
    		puts "its a draw"
    	else 
    		puts "dealer wins"
    	end 
    	play_again
    end
    			
 def play_again
 	  puts ""
 	  puts "want to play again 1) yes  2) no"
     answer = gets.chomp
     if answer == '2' 
     	exit
     elsif answer == '1'
    deck = Deck.new
    player.cards = []
    dealer.cards = []
    deal_cards
		show_flop
		player_turn
		dealer_turn
		who_won?
	end
	end

	def start
		set_player_name
		deal_cards
		show_flop
		
		player_turn
		dealer_turn
		who_won?
		play_again

  end
end


# deck = Deck.new 

# puts deck.size

# player = Player.new("karel")
# player.add_card(deck.deal_one)
# player.add_card(deck.deal_one)
# player.add_card(deck.deal_one)
# player.add_card(deck.deal_one)

# puts player.show_hand

# puts player.is_busted

# dealer = Dealer.new
# dealer.add_card(deck.deal_one)
# dealer.add_card(deck.deal_one)
# dealer.add_card(deck.deal_one)
# dealer.add_card(deck.deal_one)
# puts dealer.show_hand

# puts dealer.is_busted

game = Blackjack.new

game.start


