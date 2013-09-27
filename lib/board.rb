class Board
  attr_reader :rows # do external classes need to change the Board's @rows?
  
  def initialize(original = true)
    generate_rows
    set_pieces if original
  end
  
  def [](pos)
    row, col = pos
    @rows[row][col]
  end
  
  def []=(pos, piece)
    row, col = pos
    @rows[row][col] = piece
    piece.pos = pos unless piece.nil?
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
  
  def perform_slide(old_pos, new_pos)
    raise InvalidMoveError if unoccupied?(old_pos)
    
    possible_pos = piece_at(old_pos).slide_moves
    possible_pos.select! { |pos| on_board?(pos) && unoccupied?(pos) }

    if possible_pos.include?(new_pos)
      move_piece(old_pos, new_pos)
    else
      raise InvalidMoveError
    end
  end
  
  def perform_jump(old_pos, new_pos)
    raise InvalidMoveError if unoccupied?(old_pos)
    
    possible_pos = piece_at(old_pos).jump_moves
    possible_pos.select! do |pos|
      on_board?(pos) && can_jump_opponent?(old_pos, pos)
    end
    
    if possible_pos.include?(new_pos)
      move_piece(old_pos, new_pos)
      remove_jumped_piece(old_pos, new_pos)
    else
      raise InvalidMoveError
    end
  end
  
  def perform_moves!(*move_sequence)
    raise InvalidMoveError if move_sequence.length < 2
    remaining_moves = move_sequence
    old_pos, new_pos = remaining_moves[0], remaining_moves[1]
    
    if piece_at(old_pos).slide_moves.include?(new_pos)
      perform_slide(old_pos, new_pos)
    else
      until remaining_moves.length < 2
        old_pos = remaining_moves.shift
        new_pos = remaining_moves.first
        perform_jump(old_pos, new_pos)
      end
    end
  end
  
  # def valid_move_seq?(move_sequence)
  #   begin
  #     # dup self
  #     # call perform_moves!(move_sequence) on the duplicate
  #   rescue
  #     false
  #   else
  #     true
  #   end
  # end
  
  private
  
  def pieces
    @rows.flatten
  end
  
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
  
  def piece_at(pos)
    self[pos]
  end
  
  def on_board?(pos)
    pos.all? {|num| (0..7).cover?(num) }
  end
  
  def unoccupied?(pos)
    piece_at(pos).nil?
  end
  
  def move_piece(old_pos, new_pos)
    self[new_pos] = piece_at(old_pos)
    self[old_pos] = nil
    piece_at(new_pos).check_if_king
  end
  
  def can_jump_opponent?(old_pos, new_pos)
    between_pos = find_between_pos(old_pos, new_pos)
    !unoccupied?(between_pos) && enemy_pieces?(old_pos, between_pos)
  end
  
  def enemy_pieces?(old_pos, new_pos)
    piece_at(old_pos).color != piece_at(new_pos).color
  end
  
  def find_between_pos(old_pos, new_pos)
    [(old_pos[0] + new_pos[0])/2, (old_pos[1] + new_pos[1])/2]
  end
  
  def remove_jumped_piece(old_pos, new_pos)
    between_pos = find_between_pos(old_pos, new_pos)
    self[between_pos] = nil
  end
  
  def deep_dup
    board_copy = Board.new(false)
    
    pieces.each do |piece|
      next if piece.nil?
      board_copy[piece.pos] = piece.dup
    end
    
    board_copy
  end
end