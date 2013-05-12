puts "Welcome to My BlackJack Card Counting Trainer"
puts "Do you have what it takes to beat the dealer?"
puts "**********RULES**********"
puts "1) You start with $1000.  When your balance reaches 0, you lose"
puts "2) The dealer uses 5 decks.  The decks are rushuffled when 2 decks are dealt"
puts "3) The minimum bets is $5"

def y_play_again?
	puts "Do you want to play again?"
	go_again = gets.chomp
	go_again.downcase!
	while go_again != "yes" && go_again != "no"
		puts "You did not put in a valid response.  Say yes or no"
		go_again = gets.chomp
		go_again.downcase!
	end
	if go_again == "yes"
		return true
	elsif go_again =="no"
		return false
	end
end

#The purpose of this method is to asset me in calcuating how many points the player is at
def calculate_player_points(first_card, second_card)
	player_current_points = 0
	if first_card[0] == "A"
		player_current_points = 11
	elsif first_card[0] == "J" || first_card[0] == "Q" || first_card[0]=="K" || first_card[0]=="1"
		player_current_points = 10
	else
		player_current_points = first_card[0].to_i
	end 
	if player_current_points == 11 && second_card[0] == "A"
		player_current_points = 2
	elsif second_card[0] == "J" || second_card[0] == "Q" || second_card[0]=="K"
		player_current_points += 10
	else
		player_current_points += second_card[0].to_i
	end 
end

def calculate_subsequent_points(points, player_card)
	player_current_points = points
	if player_card[0] == "A" && player_current_points <=10
		player_current_points += 11
	elsif player_card[0] == "A" && player_current_points > 10
		player_current_points += 1
	elsif player_card[0] == "J" || player_card[0] == "Q" || player_card[0]=="K" || player_card[0]=="1"
		player_current_points += 10
	else
		player_current_points += player_card[0].to_i
	end
	return player_current_points
end

def check_win(player_total, dealer_total, player_bet)
	winnings = player_bet
	player_points = player_total
	dealer_points = dealer_total
	if player_points == 21
		puts "Winner Winner Chicken Dinner! You hit a BlackJack"
		winnings = winnings * 2.5
		return winnings
	elsif dealer_points == 21
		puts "Dealer Cards: |#{dealers_first_card}| |#{dealer_second_card}|"
		puts "The dealer revealed a #{dealer_second_card} and hit a BlackJack.  You lose."
		winnings = 0
		return winnings
	else
		return winnings
	end
end

def take_turn_dealer(first_card, second_card, deck, dealer_points)
	dealer_points_local = dealer_points
	decks = deck
	puts "The dealer has a #{first_card} and a #{second_card} for #{dealer_points_local} points"
	if dealer_points_local > 16 && dealer_points_local <= 21
		return dealer_points_local
		puts "The dealer has #{dealer_points_local} points and decides to stay"
	end
	while dealer_points_local <= 16
		dealer_draw = rand(decks.length)
		new_dealer_card = decks[dealer_draw]
		puts "The dealer hit and drew a #{decks[dealer_draw]}"
		decks.delete_at(dealer_draw)
		dealer_points_local = calculate_subsequent_points(dealer_points_local, new_dealer_card)
		puts "The dealer now has #{dealer_points_local} points"
	end
	if dealer_points_local > 21
		dealer_points_local = 0
		return dealer_points_local
	else
		return dealer_points_local
	end
end

def players_turn(the_bet)
	original_bet = the_bet
	winnings = the_bet
	cards = ["A(Spades)","2(Spades)","3(Spades)","4(Spades)","5(Spades)","6(Spades)","7(Spades)","8(Spades)","9(Spades)","10(Spades)","J(Spades)","Q(Spades)","K(Spades)","A(Hearts)","2(Hearts)","3(Hearts)","4(Hearts)","5(Hearts)","6(Hearts)","7(Hearts)","8(Hearts)","9(Hearts)","10(Hearts)","J(Hearts)","Q(Hearts)","K(Hearts)","A(Diamonds)","2(Diamonds)","3(Diamonds)","4(Diamonds)","5(Diamonds)","6(Diamonds)","7(Diamonds)","8(Diamonds)","9(Diamonds)","10(Diamonds)","J(Diamonds)","Q(Diamonds)","K(Diamonds)","A(Clubs)","2(Clubs)","3(Clubs)","4(Clubs)","5(Clubs)","6(Clubs)","7(Clubs)","8(Clubs)","9(Clubs)","10(Clubs)","J(Clubs)","Q(Clubs)","K(Clubs)"]
	select = rand(52)
	dealers_first_card = cards[select]
	cards.delete_at(select)
	select = rand(51)
	dealers_second_card = cards[select]
	cards.delete_at(select)
	select = rand(50)
	player_first_card = cards[select]
	cards.delete_at(select)
	select = rand(49)
	player_second_card = cards[select]
	puts "Dealer Cards: |#{dealers_first_card}| |?????|"
	puts "-------------------------------------"
	puts "Your Cards:   |#{player_first_card}| |#{player_second_card}|"
	player_points = calculate_player_points(player_first_card, player_second_card)
	dealer_points = calculate_player_points(dealers_first_card,dealers_second_card)
	winnings = check_win(player_points, dealer_points, winnings)
	if winnings != original_bet 
		return winnings
	else
		puts "The dealer is showing a #{dealers_first_card}."
		puts "You have #{player_points} points"
		
			puts "What do you want to do? (Hit / Stay / Double Down/)"
			p_decision = gets.chomp
			p_decision.downcase!
			while p_decision != "hit" && p_decision != "stay" && p_decision != "double down"
				puts "Please enter a valid response"
				p_decision = gets.chomp
				p_decision.downcase!
			end
			if p_decision == "double down"
				dd_bet = winnings
				select = rand(48)
				player_dd_card = cards[select]
				cards.delete_at(select)
				puts "You drew a #{player_dd_card}"
				player_points = calculate_subsequent_points(player_points,player_dd_card)
				puts "You now have #{player_points} points"
				puts "The dealer is showing a #{dealers_second_card}!"
				winnings = check_win(player_points, dealer_points, winnings*2)
				if player_points > 21
					puts "You busted and lost all your bets!"
					winnings = 0
					winnings -= dd_bet
					return winnings
				end
			else
				counter = 0
				while p_decision == "hit" && player_points <21
					select = rand(48-counter)
					counter = counter + 1
					player_extra_card = cards[select]
					puts "You drew a #{player_extra_card}!"
					cards.delete_at(select)
					player_points = calculate_subsequent_points(player_points, player_extra_card)
					puts "You now have #{player_points} points"
					if player_points > 21
						puts "You bust!"
						winnings = 0
						return winnings
					elsif player_points == 21
						puts "You hit BlackJack!"
						winnings = winnings *2.5
						return winnings
					else
						puts "Do you want to hit (type hit to hit again)?"
						p_decision = gets.chomp
						p_decision.downcase!
						if p_decision != "hit" && p_decision != "stay"
							puts "Please enter a valid decision"
							p_decision = gets.chomp
							p_decision.downcase!
						end
					end
				end
			end
		dealer_points = take_turn_dealer(dealers_first_card, dealers_second_card, cards, dealer_points)
		if player_points > dealer_points
			puts "You won and received #{winnings} additional dollars!"
			return winnings * 2
		elsif player_points == dealer_points
			puts "You tied and got your money back."
			return winnings
		else
			winnings = 0
			puts "You lost and the dealer took you bet!"
			return winnings
		end
	end
end

#This is the main method that initiates that gain and begins running it
def main
	puts "Do you want to play? (Yes / No)"
	playing = gets.chomp
	playing.downcase!
	while playing != "yes" && playing != "no"
		puts "You did not put in a valid response.  Say yes or no"
		playing = gets.chomp
		playing.downcase!
	end
	if playing == "yes"
		playing = true
	elsif playing == "no"
		playing = false
	end
	bank_account = 1000
	while playing == true && bank_account > 0
		puts "You have $#{bank_account} in your bank"
		puts "How much would you like to bet?"
		player_bet = gets.chomp
		player_bet = player_bet.to_i
		bank_account = bank_account-player_bet
		winnings = players_turn(player_bet)
		bank_account = bank_account + winnings
		playing = y_play_again?
	end
end

main
puts "Thank you for playing!"

