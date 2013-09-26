class Piece
  attr_reader :color, :board # these should NEVER need to be changed
  attr_accessor :pos # remember to update position in both piece and board
  
  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
  end
end