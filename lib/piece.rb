class Piece
  attr_reader :color, :board # these should NEVER need to be changed
  attr_accessor :pos # remember to update position in both piece and board
  
  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
    @king = false
    @orientation = color == :red ? 1 : -1
  end

  def render # will be called through Board's render
    symbol[color]
  end
  
  def slide_moves
    [].tap do |new_positions|
      slide_directions = [[@orientation, -1], [@orientation, 1]]
      slide_directions.each do |direction|
        new_positions << [direction[0] + pos[0], direction[1] + pos[1]]
      end
    end
  end
  
  def jump_moves
    [].tap do |new_positions|
      jump_directions = [[@orientation * 2, -2], [@orientation * 2, 2]]
      jump_directions.each do |direction|
        new_positions << [direction[0] + pos[0], direction[1] + pos[1]]
      end
    end
  end
  
  private
  
  def symbol
    { red: "R", white: "W" }
  end
  
  def can_become_king? #this can be a check done after every time the piece moves
    color == red ? pos[0] == 7 : pos[0] == 0
  end
  
  def become_king
    @king = true
  end
end