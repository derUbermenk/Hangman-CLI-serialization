module Display
  # main display
  def display_initial_user_prompt
    print 'do you want to play or load: '
  end

  ## saves
  def display_choose_saves
    print'Choose save by number: '
  end

  def display_invalid_input
    puts 'Invalid input, input must be within the given range'
  end

  def display_invalid_input_group (saves)
    display_invalid_input
    display_all_saves(saves)
    display_choose_saves
  end

  # @param saves [Array]
  def display_all_saves(saves)
    puts " \nSaved games: "
    saves.map do |key, value|
      puts "#{value.split('.')[0]} [#{key}]"
    end.join(' ')
    puts "--------------------- \n "
  end

  # Game display

  # @param word [Hash] where key is place holder, value is actual char
  # @param player_life [Int]
  def display_guess_status(word, player_life)
    keys = word.keys.map do |key| 
      "[#{key}]"
      # key.instance_of?(Integer) ? "#{[key]} " : key
    end
    puts " #{keys.join(' ')} \n  #{player_life} "
  end

  def display_save_name_prompt
    print 'enter save name [no numbers spaces allowed]: '
  end

  def display_game_saved
    puts 'game saved'
  end

  def display_quit_message
    puts 'game quit'
  end

  def display_guessed_message
    puts 'game won'
  end

  def display_no_turns_left_message
    puts 'no turns left'
  end

  # Player display
  def display_player_input_prompt
    puts "s - save \nq - quit \nposition guess - to guess"
    print "\nenter move: "
  end
end
