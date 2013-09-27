class Piece
  attr_reader :color, :board
  attr_accessor :pos
  
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
      slide_directions.each do |direction|
        new_positions << [direction[0] + pos[0], direction[1] + pos[1]]
      end
    end
  end
  
  def jump_moves
    [].tap do |new_positions|
      jump_directions.each do |direction|
        new_positions << [direction[0] + pos[0], direction[1] + pos[1]]
      end
    end
  end
  
  def check_if_king
    @king = true if can_become_king?
  end
  
  private
  
  def symbol
    @king ? { red: "R", white: "W" } : { red: "r", white: "w" }
  end
  
  def can_become_king?
    color == :red ? pos[0] == 7 : pos[0] == 0
  end
  
  def slide_directions
    reg_directions = [[@orientation, -1], [@orientation, 1]]
    return reg_directions unless @king
    both_directions(reg_directions)
  end
  
  def jump_directions
    reg_directions = [[@orientation * 2, -2], [@orientation * 2, 2]]
    return reg_directions unless @king
    both_directions(reg_directions)
  end
  
  def both_directions(reg_directions)
    reg_directions + reg_directions.map {|dir| [dir[0] * -1, dir[1]] }
  end
end