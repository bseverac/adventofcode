#!/usr/bin/ruby
require 'matrix'
require 'test/unit'
require 'pry'
require 'digest'

class Deck
  attr_accessor :current, :cards
  def initialize(name, cards)
    @name = name
    @cards = cards
  end

  def deals
    @current = @cards.shift
    #puts "#{@name} play #{current}"
    @current
  end

  def win(cards)
    #puts "#{@name} win #{cards}"
    @cards += cards
  end

  def debug
    #puts "#{@name} decks #{@cards}"
  end

  def sub_deck
    Deck.new(@name, @cards[0...@current])
  end

  def self.file(data)
    name = data.split("\n")[0]
    cards = data.split("\n")[1..-1].map(&:to_i)
    Deck.new(name, cards)
  end
end

class Game
  attr_accessor :id, :locked, :lines, :player1, :player2
  def initialize(player1, player2)
    @footprints = []
    @round = 1
    @player1 = player1
    @player2 = player2
    @players = [@player1, @player2]
  end

  def play_game_1
    play_round while can_play?
  end

  def play_round
    player1.debug
    player2.debug
    deals
    player1_win(player1_higthest?)
    @round += 1
  end

  def play_game_2
    play_round_2 while can_play?
    return !player1.cards.empty?
  end

  def play_round_2
    player1.debug
    player2.debug
    return if in_a_loop!
    deals
    if need_sub_game?
      game = Game.new(player1.sub_deck, player2.sub_deck)
      player1_win(game.play_game_2)
    else 
      player1_win(player1_higthest?)
    end
    @round += 1
  end

  def need_sub_game?
    player1.current <= player1.cards.count && player2.current <= player2.cards.count
  end

  def player1_win(bool)
    if bool
      player1.win([player1.current, player2.current])
    else
      player2.win([player2.current, player1.current])
    end
  end

  def in_a_loop!
    footprint = Digest::MD5.hexdigest "#{player1.cards.to_s} - #{player2.cards.to_s}"
    player2.cards.clear if @footprints.include? footprint
    @footprints << footprint
    return player2.cards.empty?
  end

  def score
    game_winner.cards.reverse.map.with_index {|v, i| v * (i+1)}.sum
  end

  def deals
    player1.deals
    player2.deals
  end

  def player1_higthest?
    player1.current > player2.current
  end

  def can_play?
    @players.all? {|d| !d.cards.empty? }
  end

  def game_winner
    @players.find {|d| !d.cards.empty? }
  end

  def self.file(name)
    File.read(name).split("\n\n").map { |data| Deck.file(data) }
  end
end

class Day22Test < Test::Unit::TestCase
  def test_star_1
    game = Game.new('data_test.txt')
    game.play_game_1
    assert_equal 306, game.score
  end

  def test_star_1_final
    game = Game.new('data.txt')
    assert_equal 33559, game.score
  end

  def test_star_2_test
    game = Game.new(*Game.file('data_test.txt'))
    game.play_game_2
    assert_equal 291, game.score
  end

  def test_star_2_final
    game = Game.new(*Game.file('data.txt'))
    game.play_game_2
    assert_equal 32789, game.score
  end
end
