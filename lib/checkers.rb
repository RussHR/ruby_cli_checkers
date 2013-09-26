require_relative 'user'
require_relative 'piece'
require_relative 'board'

require 'debugger'

class Checkers
  attr_reader :board
  
  def initialize
    @board = Board.new
  end
end