require_relative 'computer'
require_relative 'player'
require_relative 'array_addition'
include Computer

colors=["red", "blue", "green", "black", "white", "yellow"]
#Initializing game
puts "Welcome to Alex Chi's Mastermind game!"
puts "What is your name?"
name=gets.chomp
puts "Would you like to guess the code or provide a code for the computer to guess?"
puts " Type 'Y' to guess a code or 'N' to provide a code"
mode=gets.chomp.downcase
#Checking to determine whether mode decision is valid.
while (mode!='y')&&(mode!='n')
	puts "That is not a valid option"
	puts " Type 'Y' to guess a code or 'N' to provide a code"
	mode=gets.chomp.downcase
end
#Initialzing players.
player=Player.new(name, [], [])
computer=Player.new("Hal 9000", [], [])
#Starting loop where player guesses computer's code.
if mode=='y'
	counter=0
	computer.code=[colors.sample, colors.sample, colors.sample, colors.sample]
	while counter<12
		puts "Try to crack the computer's code. Submit your guess as 'color color color color'."
		puts "Your color options are red, blue, green, black, white, and yellow"
		guess=gets.chomp.split(" ")
		revised_guess=guess
		revised_computer_code=computer.code.dup
		validating=true
		absolutely_correct=0
		correct_color=0
		marker_array=[0,0,0,0]
		#Checking to see whether guess is valid
		while guess.size<4
			puts "You didn't list four colors"
			puts "Try again:"
			guess=gets.chomp.split(" ")
		end

		while validating==true
			validating=false
			guess.each do |element|
				if colors.include?(element)==false
					validating=true
					puts "At least one of the things you listed isn't a valid color."
					puts "Submit your guess as 'color color color color'."
					guess=gets.chomp.split(" ")
				end
			end
		end
		#Seeing how many are absolutely correct.
		guess.each_with_index do |color, index|
			if color == computer.code[index]
				absolutely_correct+=1
				marker_array[index]=1
			end
		end
		#Seeing how many are the correct color.
		marker_array.each_with_index do |marker, index|
			if marker==1
				revised_guess[index]="delete"
				revised_computer_code[index]="delete"
			end
		end
		revised_guess=revised_guess-["delete"]
		revised_computer_code=revised_computer_code-["delete"]
		correct_color=revised_guess.real_intersection(revised_computer_code).size

		
		puts "******#{absolutely_correct} peg(s) with correct position and color.*******"
		puts "******#{correct_color} peg(s) with correct color but wrong position.******"
		#puts "---------------------------"
		#puts computer.code
		#puts "---------------------------"
		#puts revised_guess
		#puts "---------------------------"
		#puts revised_computer_code
		
		counter+=1
		if absolutely_correct==4
			puts "*****Congratulations, you cracked the computer's code!**********"
			puts "*****It took you #{counter} turns."
			counter=12
		elsif counter==12
			puts "Sorry, you weren't able to crack the code in twelve turns."
			print "Computer's code: #{computer.code}"
		end
	end
elsif mode=='n'
	validating=true
	puts "The computer is going to try to guess your code."
	puts "please enter four colors separated by a space (red, blue, green, black, white, or yellow)"
	player_code=gets.chomp.downcase.split(' ') 
	while player_code.size<4
			puts "You didn't list four colors"
			puts "Try again:"
			player_code=gets.chomp.split(" ")
	end
	while validating==true
		validating=false
		player_code.each do |element|
			if colors.include?(element)==false
				validating=true
				puts "At least one of the things you listed isn't a valid color."
				puts "Submit your code as 'color color color color'."
				player_code=gets.chomp.split(" ")
			end
		end
	end
	counter=0
	
	color_hash=Hash.new
	optimal_array=[]
	

	while counter<12
		if counter==6
			color_hash.each do |key,value|
				if value!=0
					i=0
					while i<value
						optimal_array<<key
						i+=1
					end
				end
			end
		end
		computer_guess=[]
		if counter<6
			computer_guess=Computer.color_count(counter)
		else
			computer_guess=optimal(optimal_array)
		end
		absolutely_correct=0
		correct_color=0
		marker_array=[0,0,0,0]
		revised_computer_guess=computer_guess.dup
		revised_player_code=player_code.dup
		

		computer_guess.each_with_index do |color, index|
			if color == player_code[index]
				absolutely_correct+=1
				marker_array[index]=1
			end
		end
		
		marker_array.each_with_index do |marker, index|
			if marker==1
				revised_computer_guess[index]="delete"
				revised_player_code[index]="delete"
			end
		end
		revised_computer_guess=revised_computer_guess-["delete"]
		revised_player_code=revised_player_code-["delete"]
		correct_color=revised_computer_guess.real_intersection(revised_player_code).size
		case counter
		when 0
			color_hash["red"]=absolutely_correct
		when 1
			color_hash["blue"]=absolutely_correct
		when 2
			color_hash["green"]=absolutely_correct
		when 3
			color_hash["black"]=absolutely_correct
		when 4
			color_hash["white"]=absolutely_correct
		when 5
			color_hash["yellow"]=absolutely_correct
		end

		puts "Computer's guess: #{computer_guess}"
		puts "******#{absolutely_correct} peg(s) with correct position and color.*******"
		puts "******#{correct_color} peg(s) with correct color but wrong position.******"
		counter+=1
		if absolutely_correct==4
			puts "*****The computer cracked your code!**********"
			puts "*****It took the computer #{counter} turns."
			counter=12
		elsif counter==12
			puts "The computer was not able to crack your code in twelve turns"
		end
	end
end





