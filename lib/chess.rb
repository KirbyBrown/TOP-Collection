class Board
	attr_accessor :square, :grid, :turn, :captured, :check, :mate

	def initialize
		@grid = Array.new(8){ |i|
			i = Array.new(8){ |j|
				j = nil
			} }
#		puts @grid[0].inspect
		@grid[6].map! { |i| i = Piece.new(i, 6, Pawn, 1) }
		@grid[1].map! { |i| i = Piece.new(i, 1, Pawn, 2) }
		@grid[7][0] = Piece.new(7, 0, Rook, 1)
		@grid[7][7] = Piece.new(7, 7, Rook, 1)
		@grid[0][0] = Piece.new(0, 0, Rook, 2)
		@grid[0][7] = Piece.new(0, 7, Rook, 2)
		@grid[7][1] = Piece.new(7, 1, Knight, 1)
		@grid[7][6] = Piece.new(7, 6, Knight, 1)
		@grid[0][1] = Piece.new(0, 1, Knight, 2)
		@grid[0][6] = Piece.new(0, 6, Knight, 2)
		@grid[7][2] = Piece.new(7, 2, Bishop, 1)
		@grid[7][5] = Piece.new(7, 5, Bishop, 1)
		@grid[0][2] = Piece.new(0, 2, Bishop, 2)
		@grid[0][5] = Piece.new(0, 5, Bishop, 2)
		@grid[7][3] = Piece.new(7, 3, Queen, 1)
		@grid[0][3] = Piece.new(0, 3, Queen, 2)
		@grid[7][4] = Piece.new(7, 4, King, 1)
		@grid[0][4] = Piece.new(0, 4, King, 2)

#		puts @grid[0].inspect

		@turn = 0
		@captured = []
		@check = 0
		@mate = 0
	end

	def display
		disp = []
		cap_disp = []
		@grid.each{|i| i.each {|j| j == nil ? disp << "_" : disp << j.icon }}
		@captured.each{|i| cap_disp << i.icon }
		
		puts "   a  b  c  d  e  f  g  h  "
		puts "8  #{disp[0..7].join("  ")}"
		puts "7  #{disp[8..15].join("  ")}"
		puts "6  #{disp[16..23].join("  ")}"
		puts "5  #{disp[24..31].join("  ")}"
		puts "4  #{disp[32..39].join("  ")}"
		puts "3  #{disp[40..47].join("  ")}"
		puts "2  #{disp[48..55].join("  ")}"
		puts "1  #{disp[56..63].join("  ")}"
		puts ""
		puts "Captured: #{captured == [] ? 'nothing' : cap_disp.join('')}"
	end

	def is_piece?(square)
#		puts "the square is: #{square.inspect}"
		false if square.nil?
		false if square[0].nil?
		false if square[1].nil?
		grid[square[0]][square[1]] == nil ? false : true
	end

	def on_board?(square)
		if square[0] == nil || square[1] == nil
			return false
		elsif square[0].between?(0,7) && square[1].between?(0,7) 
			return true 
		else 
			return false
		end
	end

	def invalid_square_selected
		puts "That square isn't on the board! Try again."
		@turn -= 1
		play_turn
	end

	def empty_square_selected
		puts "You picked a square without a piece on it,"
		puts "let's try again."
		@turn -= 1
		play_turn
	end

	def illegal_move(from)
		puts "That isn't a legal move for #{grid[from[0]][from[1]]}!"
		puts "Let's try again."
		@turn -= 1
		play_turn
	end

	def square_occupied_by_self?(square)
		return false if grid[square[0]][square[1]].nil?
		allegiance = grid[square[0]][square[1]].player
#		puts allegiance
#		puts "Current: #{@current_player}"
		allegiance == @current_player ? true : false
	end

	def suicide_attempt
		puts "You can't take your own piece!"
		puts "Give that another shot."
		@turn -= 1
		play_turn
	end

	def check?(player)
		agressor = 0
		player == 2 ? agressor = 1 : agressor = 2
		grid.each_with_index do |x, i|
#			puts x
#			puts i
#			puts "Once"
			x.each_with_index do |y, j|
#				puts "y: #{y}"
#				puts "j: #{j}"
				if y != nil
					if y.type == King && y.player == player
						king_pos = [i,j]
						puts "Player #{player}s King is at:"
						puts king_pos
						puts "\n"
					end
				end
			end
		end
		threatening_pieces = []
		for i in 0..7
			for j in 0..7
#				puts "Line 132ish #{i}, #{j}"
				target = grid[i][j]
				if is_piece?([i,j]) && square_occupied_by_self?([i,j])
					if on_board?(to)
						if (legal_route?([i,j], [king_pos]) && trace_route([i,j], [king_pos]))
							if square_occupied_by_self?([king_pos])
								suicide_attempt
							else
								threatening_pieces << [i,j] 
							end
						else
							false
						end
					else
						false
					end
				else
					false
				end
			end
		end
		puts "and is threatened by #{threatening_pieces.inspect}"
		threatening_pieces == [] ? false : checkmate?(thretening_piece, king_pos)
	end

	def checkmate?(threatening_pieces, king_pos)
		agressor = threatening_pieces[0].player
		agressor == 2 ? player = 1 : player = 2
		if threatening_pieces.length == 2

		else
			for i in -1..1
				for j in -1..1
			test_board = grid.dup
			test_board.move_piece(king_pos)




	end

	def name_square(input)
		name_piece = []
		n_p = input.split("")
#		resign if n_p == ["r", "e", "s", "i", "g", "n"]
#		puts n_p.inspect
		name_piece[1] = n_p[0].downcase.bytes.pop

		name_piece[1] -= 97
		reversing_array = [7, 6, 5, 4, 3, 2, 1, 0]
		name_piece[0] = reversing_array[n_p[1].to_i - 1]
		puts name_piece.inspect
		name_piece
	end

	def get_input
		input = gets.chomp
		handle_input(input)
	end

	def handle_input(input)
		case input
		when "r"
			resign
		else
			name_square(input)
		end
	end

	def play_turn
		display
		@turn += 1
		@current_player = 0
		@turn % 2 == 1 ? @current_player = 1 : @current_player = 2
		from = []
		to = []
		puts "What piece would you like to move?"
		from = get_input



		puts "To where would you like it moved?"
		to = get_input


		move_piece(from, to) if can_it_move?(from, to)
		game_over? ? game_over_report : play_turn

	end

	def can_it_move?(from, to)
		if is_piece?(from) && square_occupied_by_self?(from)
			if on_board?(to)
				if (legal_route?(from, to) && trace_route(from, to))
					if square_occupied_by_self?(to)
						suicide_attempt
					else
						true
					end
				else
					illegal_move(from)
				end
			else
				empty_square_selected
			end
		else
			invalid_square_selected
		end
	end

	def in_file?(from, to)
		from[1] - to[1] == 0 ? true : false
	end

	def in_rank?(from, to)
		from[0] - to[0] == 0 ? true : false
	end

	def on_diagonal?(from, to)
		file = from[0] - to[0]
		rank = from[1] - to[1]
		file.abs == rank.abs ? true : false
	end

	def knight_move?(from, to)
		legal_routes = [[1,2],[2,1],[-1,2],[-2,1],[1,-2],[2,-1],[-1,-2],[-2,-1]]
		move_route = []
		move_route[0] = to[0] - from[0]
		move_route[1] = to[1] - from[1]
		legal_routes.include?(move_route) ? true : false
	end

	def only_one_step?(from, to)
		file = from[0] - to[0]
		rank = from[1] - to[1]
		puts file
		puts rank
		file.between?(-1,1) && rank.between?(-1,1) ? true : false
	end

	def forward_move?(from, to)
		progress = to[0] - from[0]
		case @current_player
		when 1
			progress <= 0 ? true : false
		when 2
			progress <= 0 ? false : true
		end
	end

	def valid_en_passant?(from, to)
		return false unless on_diagonal?(from, to) && only_one_step?(from, to)
		return false if grid[from[0]][to[1]].nil?
		return false if grid[from[0]][from[1]].en_passant_eligible = false
		captured << grid[from[0]][to[1]]
		grid[from[0]][to[1]] = nil
		return true
	end

#The castle method has not been tested. 
#Anticipate possible problem of rook attempting to take the king after castling is complete.
	def castle(from, to)
		if from.has_moved == false && trace_route == true
			rook_from = 7 if to[1] == 6
			rook_from = 0 if to[1] == 1
			
			kingtomove = grid[from[0]][from[1]]
			rooktomove = grid[7][to[1]]
			destination = grid[to[0]][to[1]]
			grid[to[0]][to[1]] = kingtomove
			grid[from[0]][from[1]] = rooktomove
			grid[7][to[1]] = nil
			grid[to[0]][to[1]].has_moved = true
		else
			false
		end
	end

	def pawn_move?(from, to)
		rank = from[0] - to[0]
		file = from[1] - to[1]
#		puts "File is: #{file}"
		if file == 0
#			puts "No Capture"
			if 	forward_move?(from, to)
				if only_one_step?(from, to)
					grid[from[0]][from[1]].en_passant_eligible = false
					true
				elsif grid[from[0]][from[1]].has_moved == false && (from[0] - to[0] == 2 || from[0] - to[0] == -2)
					grid[from[0]][from[1]].en_passant_eligible = true
					true
				else
					false
				end
			else
				false
			end
		else
#			puts "Capture? #{grid[to[0]][to[1]]}"
			return true unless grid[to[0]][to[1]] == nil
#			puts "LINE 228ish"
#			return true
			#
			#grid[from[0]][from[1]].en_passant_eligible = false
			valid_en_passant?(from, to) ? true : false
		end
	end

					



#		if forward_move?(from, to)
#			if in_file?(from, to)
#				if only_one_step?(from, to)
#					true
#				elsif grid[from[0]][from[1]].has_moved? 
#					valid_en_passant?(from, to)
#				else
#					false
#				end
#			else
#				false
#			end			
#		else
#			false
#		end
#	end
	def legal_route?(from, to)
		piece = grid[from[0]][from[1]]
		case 
		when piece.type == Rook
			in_rank?(from, to) ^ in_file?(from, to) ? true : false
		when piece.type == Knight
			knight_move?(from, to) ? true : false
		when piece.type == Bishop
			on_diagonal?(from, to) ? true : false
		when piece.type == Queen
			on_diagonal?(from, to) || in_file?(from, to) || in_rank?(from, to) ? true : false
		when piece.type == King
			if only_one_step?(from, to)
				on_diagonal?(from, to) || in_file?(from, to) || in_rank?(from, to) ? true : false
			elsif from[1] - to[1] == -2 || from[1] - to[1] == -3
				castle(from, to) ? true : false
			else
				false
			end
		when piece.type == Pawn
#			puts "Line 274ish: "
			pawn_move?(from, to) ? true : false
#			puts "#{h}"
#			return h
		end
	end

#	def obstructed?(from, to)
#
#	end

	def trace_route(from, to)
		puts "#{grid[from[0]][from[1]].type}"
		return true if grid[from[0]][from[1]].type == Knight
		rank_direction = to[0] <=> from[0]
		file_direction = to[1] <=> from[1]
		rank_change = from[0] - to[0]
		file_change = from[1] - to[1]
		adder = []
		check_square = from
		if rank_direction == 1
			(a,b = from[0],to[0])
			adder[0] = 1
		else
			(a,b = to[0],from[0])
			adder[0] = -1
		end
		if file_direction == 1
			(c,d = from[1],to[1])
			adder[1] = 1
		else
			(c,d = to[1],from[1])
			adder[1] = -1
		end
#		puts "Variables assigned: \n a = #{a} b = #{b} c = #{c} d = #{d}"
		square_status = []
		if rank_change != 0 && file_change != 0
#			puts "Diagonal Move!"
			for i in a...b-1
#				puts "i = #{i}"
				check_square = [check_square, adder].transpose.map {|x| x.reduce(:+)} 
				is_piece?(check_square) ? square_status << false : square_status << true
			end
#			i = a+1
#			j = c+1
#			while i < b
#				i += 1
#				j += 1
#				is_piece?([i,j]) ? square_status << false : square_status << true
#			end
		elsif rank_change != 0
			puts "310ish"
			for i in a+1...b do
#				puts "i = #{i}"
				is_piece?([i,c]) ? square_status << false : square_status << true
			end
		elsif file_change != 0
			puts "316ish"
			for i in c+1...d do
#				puts "i = #{i}"
				is_piece?([a,i]) ? square_status << false : square_status << true
			end
		else
			illegal_move
		end
#		puts "square status: #{square_status.inspect}"
		if square_status.include?(false)
#			puts "returning FALSE"
			return false
		else
#			puts "returning TRUE"
			return true
		end
	end

	def move_piece(from, to)
		tomove = grid[from[0]][from[1]]
#		puts tomove.inspect
#		puts tomove.inspect
		destination = grid[to[0]][to[1]]
		captured << destination if destination != nil
		grid[to[0]][to[1]] = tomove
		grid[from[0]][from[1]] = nil
		grid[to[0]][to[1]].has_moved = true
		grid[to[0]][to[1]].position = to
#		play_turn
	end

	def game_over?
		@checkmate == 1 ? true : false
	end

	def game_over_report
		puts "Game Over"
		puts "Player #{@current_player} has won!"
	end

	def resign
		who = @current_player == 1 ? "White" : "Black"
		puts "The #{who} player has resigned."
		return false
	end
end

#class Player
#	def initialize
#
#	end
#end

class Piece
	attr_accessor :position, :type, :player, :piece, :icon, :has_moved, :en_passant_eligible#, :square_exists

	def initialize(x, y, type, player)
		@position = [x,y]
		@type = type
		@player = player
		@piece = @type.new(@player)
		@icon = @piece.icon
		@has_moved = false
		@en_passant_eligible = false
	end

#	def move
#		self.square_exists?
#		self.type.legal_routes
#	end

#	def square_exists?(destination)
#		8 >= destination[0] && destination[0] >= 0 ? true : false
#		8 >= destination[1] && destination[1] >= 0 ? true : false
#	end
end

class Pawn < Piece
	attr_accessor :icon#, :en_passant_eligible
	def initialize(player)
		@player = player
		@icon = @player == 2 ? "\u2659" : "\u265F"
#		@en_passant_eligible = false
	end

#	def legal_routes
#		if @player == 1
#			[[1, 1], [-1, 1]]
#		else
#			[[1, -1], [-1, -1]]
#		end
#	end
end

class Rook < Piece
	attr_accessor :icon, :legal_route#, :castling_eligible
	def initialize(player)
		@player = player
		@icon = @player == 2 ? "\u2655" : "\u265C"
#		@castling_eligible = true
	end

#	def legal_route(destination)
#		if destination[0] == self.position[0] && destination[1] == self.position[1]
#			return false
#		elsif destination[0] != self.position[0] && destination[1] != self.position[1]
#			return false
#		else 
#			return true
#		end
#	end
end

class Knight < Piece
	attr_accessor :icon
	def initialize(player)
		@player = player
		@icon = @player == 2 ? "\u2658" : "\u265E"
	end

end

class Bishop < Piece
	attr_accessor :icon
	def initialize(player)
		@player = player
		@icon = @player == 2 ? "\u2657" : "\u265D"
	end

end

class Queen < Piece
	attr_accessor :icon
	def initialize(player)
		@player = player
		@icon = @player == 2 ? "\u2655" : "\u265B"
	end

end

class King < Piece
	attr_accessor :icon#, :castling_eligible
	def initialize(player)
		@player = player
		@icon = @player == 2 ? "\u2654" : "\u265A"
#		@castling_eligible = true
		@in_check = 0
	end

end


game = Board.new
#game.display
game.check?(1)
#puts game.inspect
#game.play_turn

#game.move_piece([0,0], [6,0])
#puts "\u2659 \u265F \u2655 \u265C"