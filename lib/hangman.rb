class Game
  @@gameover = false
  @@max_fails = 10

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

  def check_gameover(hidden_solution, solution_arr, wrong_word_count)
    if hidden_solution == solution_arr
      @@gameover = true
    elsif wrong_word_count == @@max_fails
      @@gameover = true
    end
  end

  def play
    wrong_word_count = 0
    round = 1
    
    solution_arr = random_word.split("") #get random word from dict
    hidden_solution = hide_word(solution_arr) #hide word
    
    puts "===================="
    puts "#{hidden_solution.join("")}"
    puts "===================="
    p solution_arr #for testing purposes only
    
    while (@@gameover != true)
      puts "Round: #{round}"
      puts "Guess a letter: "
      guess = gets.strip

      solution_arr.each_with_index do |v, i|
        if v == guess
          hidden_solution[i] = guess
        end
      end

      if hidden_solution.include?(guess) == false
        wrong_word_count += 1
      end

      check_gameover(hidden_solution, solution_arr, wrong_word_count)

      puts "===================="
      puts "#{hidden_solution.join("")}"
      puts "===================="
      puts "Incorrect words: #{wrong_word_count}"
      
      round += 1
    end

    puts "Game Over"

    if wrong_word_count >= @@max_fails
      puts "You Lose"
    else
      puts "You Win"
    end
  end
end

new_game = Game.new
new_game.play