class GameDeck
  attr_accessor :deck, :game_deck, :n, :cards_dealt, :original_game_deck

  def initialize(n)
    @n = n
    @deck = ["A(Spades)","2(Spades)","3(Spades)","4(Spades)","5(Spades)","6(Spades)","7(Spades)","8(Spades)","9(Spades)","10(Spades)","J(Spades)","Q(Spades)","K(Spades)","A(Hearts)","2(Hearts)","3(Hearts)","4(Hearts)","5(Hearts)","6(Hearts)","7(Hearts)","8(Hearts)","9(Hearts)","10(Hearts)","J(Hearts)","Q(Hearts)","K(Hearts)","A(Diamonds)","2(Diamonds)","3(Diamonds)","4(Diamonds)","5(Diamonds)","6(Diamonds)","7(Diamonds)","8(Diamonds)","9(Diamonds)","10(Diamonds)","J(Diamonds)","Q(Diamonds)","K(Diamonds)","A(Clubs)","2(Clubs)","3(Clubs)","4(Clubs)","5(Clubs)","6(Clubs)","7(Clubs)","8(Clubs)","9(Clubs)","10(Clubs)","J(Clubs)","Q(Clubs)","K(Clubs)"]
    @original_game_deck = []
    @game_deck = []
    @cards_dealt = 0
    n.times {@deck.each{|x| @original_game_deck<<x}}
    @game_deck = @original_game_deck
  end

  def deal_card
    card_spot = rand(208-@cards_dealt)
    card_que = game_deck[card_spot]
    game_deck.delete_at(card_spot)
    self.cards_dealt += 1
    game_deck = original_game_deck if cards_deal > 51
    card_que
  end
end

Class Dealer
  attr_accessor :points, :hand

  def initialize
    @points = 0
    @hand = []
  end
  
  def calculate_points(card1, card2)
    case card1
      when card1[0] =="K" || card1[0] =="Q" || card1[0] =="J" || card1[0] =="1" then points += 10
      when card1[0] == "A" then points +=11
      else
      	points += card1[0].to_i
    end

    case card2
      when card2[0] =="K" || card2[0] =="Q" || card2[0] =="J" || card2[0] =="1" then points += 10
      when card2[0] =="A" && points < 11 then points += 11
      when card2[0] =="A" && points > 10 then points += 1
      else
        points += card2[0].to_i
    end
  end

  def calculate_subsequent_points(another_card)
    case another_card
      when another_card[0] =="K" || another_card[0] =="Q" || another_card[0] =="J" || another_card[0] =="1" then points += 10
      when another_card[0] =="A" && points < 11 then points += 11
      when another_card[0] =="A" && points > 10 then points += 1
      else
        points += another_card[0].to_i
    end
  end

  def first_turn(card1, card2)
    hand << card1
    hand << card2
    calculate_points(card1, card2)
  end

  def subsequent_turn(a_card)
    hand << a_card
    calculate_subsequent_points(a_card)    
  end
end

bob = Dealer.new
puts bob.points
puts bob.hand[0]