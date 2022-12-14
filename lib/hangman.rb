require 'yaml'

class Game
  @@gameover = false
  @@max_fails = 10

  def save_game(round, wrong_letter_count, wrong_letter_arr, solution_arr, hidden_solution)
    save_format = { state: @@gameover,
                    round: round,
                    wrong_count: wrong_letter_count,
                    wrong_arr: wrong_letter_arr,
                    solution: solution_arr,
                    hidden_solution: hidden_solution
                    }
    
    File.open("savedgames/save.yaml", "w") { |file| file.write(save_format.to_yaml) }        
  end

  def random_word
    dict = File.open("/Users/willrichards/repos/Hangman/google-10000-english-no-swears.txt", "r")
    words = []

    dict.each_line do |line|
      line.strip

      if line.length > 5 && line.length <= 12
        words.push(line)
      end
    end

    dict.close
    words.sample.gsub("\n", "")
  end

  def hide_word(solution_arr)
    hidden_solution = solution_arr.map {|v| v = "_ "}
  end

  def check_gameover(hidden_solution, solution_arr, wrong_letter_count)
    if hidden_solution == solution_arr
      @@gameover = true
    elsif wrong_letter_count == 0
      @@gameover = true
    end
  end

  def play
    wrong_letter_count = @@max_fails
    wrong_letter_arr = []
    round = 1
    
    solution_arr = random_word.split("") #get random word from dict
    hidden_solution = hide_word(solution_arr) #hide word

    puts "===================="
    puts "#{hidden_solution.join("")}"
    puts "===================="

    while (@@gameover != true)
      puts "Save game? Y/N"
      save = gets.strip.downcase

      if save == 'y'
        save_game(round, wrong_letter_count, wrong_letter_arr, solution_arr, hidden_solution)
      end

      puts "Round: #{round}"
      puts "Guess a letter: "
      guess = gets.strip.downcase

      solution_arr.each_with_index do |v, i|
        if v == guess
          hidden_solution[i] = guess
        end
      end

      if hidden_solution.include?(guess) == false
        wrong_letter_count -= 1
        wrong_letter_arr.push(guess)
      end

      check_gameover(hidden_solution, solution_arr, wrong_letter_count)

      puts "===================="
      puts "#{hidden_solution.join("")}"
      puts "===================="
      puts "Incorrect words left: #{wrong_letter_count}"
      puts "Wrong letters: #{wrong_letter_arr}"
      
      round += 1
    end

    puts "---------------------"
    puts "      Game Over      "
    puts "---------------------"

    if wrong_letter_count == 0
      puts "You Lose"
      puts "Secret word: #{solution_arr.join("")}"
    else
      puts "You Win"
    end
  end

  def continue_game
    save_hash = YAML.load(File.read("savedgames/save.yaml"))
    wrong_letter_count = save_hash[:wrong_count]
    wrong_letter_arr = save_hash[:wrong_arr]
    round = save_hash[:round]
    
    solution_arr = save_hash[:solution]
    hidden_solution = save_hash[:hidden_solution]

    puts "===================="
    puts "#{hidden_solution.join("")}"
    puts "===================="

    while (@@gameover != true)
      puts "Save game? Y/N"
      save = gets.strip.downcase

      if save == 'y'
        save_game(round, wrong_letter_count, wrong_letter_arr, solution_arr, hidden_solution)
      end

      puts "Round: #{round}"
      puts "Guess a letter: "
      guess = gets.strip.downcase

      solution_arr.each_with_index do |v, i|
        if v == guess
          hidden_solution[i] = guess
        end
      end

      if hidden_solution.include?(guess) == false
        wrong_letter_count -= 1
        wrong_letter_arr.push(guess)
      end

      check_gameover(hidden_solution, solution_arr, wrong_letter_count)

      puts "===================="
      puts "#{hidden_solution.join("")}"
      puts "===================="
      puts "Incorrect words left: #{wrong_letter_count}"
      puts "Wrong letters: #{wrong_letter_arr}"
      
      round += 1
    end

    puts "---------------------"
    puts "      Game Over      "
    puts "---------------------"

    if wrong_letter_count == 0
      puts "You Lose"
      puts "Secret word: #{solution_arr.join("")}"
    else
      puts "You Win"
    end
  end

  def menu
    puts "===================="
    puts " WELCOME TO HANGMAN "
    puts "===================="

    puts "Please select an option below:"
    puts "1) New Game"
    puts "2) Load Game"
    puts "3) Quit"
    option = gets.strip.to_i
    
    case option
    when 1
      play
    when 2
      continue_game
    when 3
      exit
    else
      menu
    end
  end
end

new_game = Game.new
new_game.menu