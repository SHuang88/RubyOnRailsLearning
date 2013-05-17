class GameDeck
  attr_accessor :deck, :game_deck, :n, :cards_dealt, :original_game_deck

  def initialize(n)
    @n = n.to_i
    @deck = ["A(Spades)","2(Spades)","3(Spades)","4(Spades)","5(Spades)","6(Spades)","7(Spades)","8(Spades)","9(Spades)","10(Spades)","J(Spades)","Q(Spades)","K(Spades)","A(Hearts)","2(Hearts)","3(Hearts)","4(Hearts)","5(Hearts)","6(Hearts)","7(Hearts)","8(Hearts)","9(Hearts)","10(Hearts)","J(Hearts)","Q(Hearts)","K(Hearts)","A(Diamonds)","2(Diamonds)","3(Diamonds)","4(Diamonds)","5(Diamonds)","6(Diamonds)","7(Diamonds)","8(Diamonds)","9(Diamonds)","10(Diamonds)","J(Diamonds)","Q(Diamonds)","K(Diamonds)","A(Clubs)","2(Clubs)","3(Clubs)","4(Clubs)","5(Clubs)","6(Clubs)","7(Clubs)","8(Clubs)","9(Clubs)","10(Clubs)","J(Clubs)","Q(Clubs)","K(Clubs)"]
    @original_game_deck = []
    @game_deck = []
    @cards_dealt = 0
    @n.times {@deck.each{|x| @original_game_deck<<x}}
    @game_deck = @original_game_deck
  end

  def deal_card
    card_spot = rand(208-@cards_dealt)
    card_que = self.game_deck[card_spot]
    self.game_deck.delete_at(card_spot)
    self.cards_dealt += 1
    self.game_deck = self.original_game_deck if self.cards_dealt > self.original_game_deck.size/5
    card_que
  end
end

class Dealer
  attr_accessor :points, :hand

  def initialize
    @points = 0
    @hand = []
  end
  
  def calculate_points
    self.points = 0
    self.hand.each{|card2|
    case card2[0]
      when "K" then self.points += 10
      when "Q" then self.points += 10
      when "J" then self.points += 10
      when "1" then self.points += 10  
      when "A" 
        self.points += 11
        self.points -=10 if self.points > 21
      else
        self.points += card2[0].to_i
    end
    }
  end

  def first_turn(card1, card2)
    self.hand << card1
    self.hand << card2
    calculate_points
  end

  def hit(card)
    self.hand << card
    calculate_points
  end

end

class Player < Dealer
  attr_accessor :bet, :bank_account, :hand, :points

  def initialize
    @bet = 0
    @bank_account = 1000
    @hand = []
    @points = 0
  end

  def place_bet(bet)
    self.bet = bet.to_i
    self.bank_account -= self.bet
  end  

  def double_down(card)
    self.bank_account -= bet
    self.bet = bet*2
    self.hand << card
    calculate_points
  end
end

class BlackJackGameEngine
  attr_accessor :wins, :losses, :name

  def initialize
	@wins = 0
    @losses = 0
    @name = ""
  end

  def play_game
  	puts "What is your name?"
  	self.name = gets.chomp
  	puts "Welcome #{self.name} to Sean & Jenny's Black Jack Card Counting Trainer!"
  	puts "******RULES******"
  	puts "1) The player starts out with $1000.  The game ends when the player quits or runs out of money"
    puts "2) The player chooses the number of decks (at least 2) to play with.  Game Deck is reshuffled when 20% of the cards are dealt"
    puts "*****************"
    puts "Do you want to play? (Yes/No)"
    playing = gets.chomp
    playing.downcase!
    while playing != "yes" && playing != "no"
    	puts "Please enter a valid response.  Would you like to play?"
    	playing = gets.chomp
    	playing.downcase!
    end
    if playing == "yes"
    	puts "How many decks would you like to play with?"
    	num_decks = gets.chomp
    	while num_decks.to_i == 0
    		puts "Please enter a valid number (at least 2 decks)!  How many decks would you like to play with?"
    		num_decks = gets.chomp
    	end
    	instance_deck = GameDeck.new(num_decks)
    	jack_dealer = Dealer.new
    	shark = Player.new
    end
    while playing == "yes"
    	puts "You currently have $#{shark.bank_account} in the bank."
    	puts "How much would you like to bet?"
    	shark.place_bet(gets.chomp)
    	jack_dealer.first_turn(instance_deck.deal_card, instance_deck.deal_card)
    	shark.first_turn(instance_deck.deal_card, instance_deck.deal_card)
    	puts "|#{jack_dealer.hand[0]}| |?????|"
    	puts "**************************************************"
    	puts "|#{shark.hand[0]}| |#{shark.hand[1]}|"
    	if jack_dealer.points == 21
    		puts "The dealer has a blackjack!"
    		puts "Would you like to play again?"
    		playing = gets.chomp 
    	elsif shark.points == 21
    		puts "Winner Winner Chicken Dinner!!"
    		shark.bank_account += shark.bet*2.5
    		puts "Would you like to play again?"
    		playing = gets.chomp 
    	else
    	  puts "The dealer is showing a #{jack_dealer.hand[0]}"
    	  puts "What would you like to do? (Hit / Stay / Double Down)"
    	  player_decision = gets.chomp
    	  player_decision.downcase!
    	  while player_decision !="stay" && player_decision !="hit" && player_decision != "double down"
    	    puts "Please enter a valid response.  What would you like to do? (Hit / Stay / Double Down)"
    		player_decision = gets.chomp
    		player_decision.downcase!
    	  end
    	  case player_decision
    	  when "hit"
    	    while player_decision == "hit" && shark.points <22
    	  	  counter = 0
    	      shark.hit(instance_deck.deal_card)
    	      puts "You drew a #{shark.hand[2+counter]}"
    	      puts "You now have #{shark.points} points!"
    	      puts "You Bust!" if shark.points > 21
    	      counter += 1
    	      unless shark.points > 21
    	    	puts "Would you like to hit again? (Yes / No)" 
    	    	answer = gets.chomp
    	    	answer.downcase!
    	    	while answer != "yes" && answer  != "no"
    	    		puts "Please enter a valid response.  Would you like to hit again?"
    	    		answer = gets.chomp
    	    	end
    	    	player_decision = "hit" if answer == "yes"
    	    	player_decision = "stay" if answer == "no"
    	      end
    	    end
    	  when "stay" 
    	  	puts "You waive to the dealer to stay"
    	  	puts "Your points equal #{shark.points}"
    	  else
    	    shark.double_down(instance_deck.deal_card)
    	    puts "You drew a #{shark.hand[2]}"
    	    puts "You now have #{shark.points} points"
    	    puts "You Bust!" if shark.points > 21
    	  end

    	  if shark.points > 21
    	  	puts "Would you like to play again?"
    	  	playing = gets.chomp
    	  else
    	  	puts "The dealer reveals a #{jack_dealer.hand[1]} for a total of #{jack_dealer.points} points"
    	  	counter = 0
    	  	while jack_dealer.points < 17
    	  	  puts "The dealer hits!"
    	  	  jack_dealer.hit(instance_deck.deal_card)
    	  	  puts "The dealer draws a #{jack_dealer.hand[2+counter]}."
    	  	  puts "The dealer now has #{jack_dealer.points} points."
    	  	  puts "The dealer busts" if jack_dealer.points > 21
    	  	  counter += 1
    	  	end
    	  	if jack_dealer.points > 21
    	  	  winnings = shark.bet*2
    	  	  puts "You Win! $#{winnings} have been added to your bank account" 
    	  	elsif shark.points > jack_dealer.points
    	  	  winnings = shark.bet*2
              puts "You Win! #{winnings} have been added to your bank account"
    	  	elsif jack_dealer.points == shark.points
    	  	  winnings = shark.bet
    	  	  puts "You Tied! $#{winnings} have been added back to your back account"
    	  	else
    	  	  puts "You Lost!"	
    	  	  winnings = 0
    	  	end
    	  	shark.bank_account += winnings
    	  	puts "Would you like to play again?"
    	  	playing = gets.chomp	 
    	  end
    	end
    end
end

game = BlackJackGameEngine.new
game.play_game
end