class Board
  attr_reader :rows # do external classes need to change the Board's @rows?
  def initialize
    generate_rows
    # call set pieces to set individual pieces
  end
  
  def generate_rows
    @rows = Array.new(8) { Array.new(8) }
  end
  
  def display
  end
end