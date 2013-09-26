class Board
  attr_reader :rows # do external classes need to change the Board's @rows?
  
  def initialize
    generate_rows
    # call set pieces to set individual pieces
  end
  
  def render # Game will need to call this
    puts " 0 1 2 3 4 5 6 7"   
    @rows.each_with_index do |row, row_num|
      print row_num
      row.each { |pos| print pos.nil? ? " |": pos.render }
      puts
    end    
    nil
  end
  
  private
  
  def generate_rows
    @rows = Array.new(8) { Array.new(8) }
  end

end