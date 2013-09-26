require_relative 'user'
require_relative 'piece'
require_relative 'board'

class Checkers
  def initialize
    @board = Board.new
  end
end