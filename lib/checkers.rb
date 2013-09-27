require_relative 'player'
require_relative 'piece'
require_relative 'board'

class Checkers
  attr_reader :board
  
  def initialize
    @board = Board.new
    @players = { white: Player.new(:white), red: Player.new(:red) }
    @current_player = :red
  end
  
  def play
    # do stuff
    
    
    # at the end, swap @current_player
  end
end