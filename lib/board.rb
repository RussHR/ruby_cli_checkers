class Board
  attr_reader :rows # do external classes need to change the Board's @rows?
  
  def initialize
    generate_rows
    set_pieces
  end
  
  def [](pos)
    row, col = pos
    @rows[row][col]
  end
  
  def []=(pos, piece) #will Piece need to access this?
    row, col = pos[0], pos[1]
    @rows[row][col] = piece
  end
  
  def render # Game will call this
    puts " 0 1 2 3 4 5 6 7"
    @rows.each_with_index do |row, row_num|
      print row_num
      row.each do |pos|
        output = pos.nil? ? " |" : pos.render + "|"
        print output
      end
      puts
    end    
    nil
  end
  
  private
  
  def generate_rows
    @rows = Array.new(8) { Array.new(8) }
  end
  
  def set_pieces
    [:red, :white].each {|color| set_team_pieces(color)}
  end
  
  def set_team_pieces(color)
    rows = color == :red ? [0, 1, 2] : [5, 6, 7]   
    rows.each do |row_num|
      col = row_num.odd? ? [0, 2, 4, 6] : [1, 3, 5, 7]
      col.each do |col_num|
        piece = Piece.new(color, self, [row_num, col_num])
        @rows[row_num][col_num] = piece
      end
    end
  end
end