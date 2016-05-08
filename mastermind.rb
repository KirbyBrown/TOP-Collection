class Gameboard
	@@colormap = ["\e[0;31;49m1\e[0m", "\e[0;33;49m2\e[0m", "\e[0;32;49m3\e[0m", "\e[0;36;49m4\e[0m", "\e[0;34;49m5\e[0m", "\e[0;35;49m6\e[0m"]
	@@colormap2 = ["\e[0;31;49mX\e[0m", "\e[0;33;49mX\e[0m", "\e[0;32;49mX\e[0m", "\e[0;36;49mX\e[0m", "\e[0;34;49mX\e[0m", "\e[0;35;49mX\e[0m"]

def initialize
	@board = Array.new
	@codekey = Array.new(4, 0)
	$role == "BREAK" ? @codekey.map!{rand(1..6)} : playerset
#	puts @codekey.inspect
end

def playerset
	puts "Enter a four digit number to represent your code:"
	code = gets.chomp.split("")
	if code.each {|digit| 
		[1..6].include?(digit)
	}
	puts "Valid Code!"
	@codekey = code
	puts @codekey
	else
	puts "Invalid Code!" 
	end
end

def show_gamestate()
	puts @@colormap.join(" ")
	puts "\e[1;30;49m\n X X X X \n\e[0m"
	puts @board
end

def win
	show_gamestate
	puts "Congratulations, you won!"
end

def lose
	
	show_gamestate
	puts "Sorry, you lost."
end

def gameover?(turn, pegs)
	if	pegs == ["\e[0;32;49m|\e[0m", "\e[0;32;49m|\e[0m", "\e[0;32;49m|\e[0m", "\e[0;32;49m|\e[0m"]
		win
	elsif turn == 12
		lose
	else
		play(turn)
	end
end

def evaluate_guess(guess, turn)
	feedback = @codekey.dup
	feedback2 = guess.dup
	pegs = ["\e[0;31;49m|\e[0m", "\e[0;31;49m|\e[0m", "\e[0;31;49m|\e[0m", "\e[0;31;49m|\e[0m"]

	feedback2.each_with_index{|f, i|
		if feedback[i] == feedback2[i]
			pegs[i] = "\e[0;32;49m|\e[0m"
			feedback[i] = 0 #eliminates bulls from feedback
			feedback2[i] = 0.5
		end
	}

	feedback2.each_with_index{|g, i|
		g2 = feedback.find_index(g)
		if	g2
			feedback[g2] = 0
			feedback2[i] = 0.5
			pegs[i] = "\e[0;33;49m|\e[0m"
		end
	}

	evaluate_return = "#{display_guess(guess)}" + " " + pegs.join("")
	@board[(turn - 1)] = evaluate_return
	gameover?(turn, pegs)
end

def valid_guess?(guess, turn)
	guess.length != 4 ? invalid_guess(guess, turn) : 
	evaluate_guess(guess, turn)
end

def invalid_guess(guess, turn)
	puts "That's not a valid guess!"
	puts "Try again!"
	play(turn - 1)
end

def display_guess(guess)
	dg = []
	guess.each_with_index{|g, i|
	dg[i] = @@colormap2[(g.to_i-1)]
	}
	return " " + dg.join(" ")
end

def human_guess(turn)
	puts "Guess Below:"
	guess = gets.chomp.split("")
	guess.map!{ |x| x.to_i}
	valid_guess?(guess, turn)
end

def computer_guess_random(turn)
	puts "The computer will make a guess:"
	guess = []
	guess.map!{rand(1..6)}
	evaluate_guess(guess, turn)
end

def play(turn)
		turn += 1
		puts "Turn #{turn}:"
		show_gamestate
	if $role == "BREAK"
		human_guess(turn)
	else
		computer_guess_random(turn)
	end

end

end

def role_valid
	if $role == "SET" || $role == "BREAK" 
		x = Gameboard.new
		x.play(0) 
	else 
		choose_role
	end

end

def choose_role
	puts "Would you prefer to SET the code or BREAK the code?"
	$role = gets.chomp
	role_valid
end


puts "Hello, welcome to Mastermind!"
puts "A colorful game of codebreaking!"
choose_role

