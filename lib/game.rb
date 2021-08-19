require 'pry-byebug'
require 'yaml'
require_relative 'display'
require_relative 'player'
require_relative 'evaluator'

class Game
  include Display

  attr_accessor :evaluator, :player, 
                :word, :choices

  def initialize
    @evaluator = Evaluator.new
    @player = Player.new
    @word = nil
    @choices = nil
  end

  def play
    binding.pry
    generate_word
    keep_playing until stop_conditions_met

    report_end_terms
  end

  private

  def generate_word
    self.word = evaluator.make_word
    self.choices = self.word.keys
  end

  def keep_playing
    display_guess_status(self.word, self.player.life)
    player_input = player.guess(self.choices)
    input_key = player_input.keys[0]

    case input_key
    when 's' then save
    when 'q' then quit('q')
    else
      evaluate(player_input)
    end
  end

  def save
    # save current game
    Dir.mkdir('saves') unless Dir.exist?('saves')

    display_save_name_prompt
    save_name = ' ' # initial save name
    save_name = "#{clean_save_name(gets.chomp)}.yml" until name_valid(save_name)
    File.open("saves/#{save_name}", 'w') { |file| file.write(self.to_yaml) }
    display_game_saved
  end

  def name_valid(name)
    name = name.split
    space = ' '
    number = /\d/

    name.include?(space) || !s[number].nil?
  end

  def evaluate(player_input)
    guess_acc = evaluator.evaluate(player_input, self.word)

    update_word(player_input) if guess_acc == true
    update_life if guess_acc == false

    display_guess_status(self.word, self.player.life)
  end

  def update_word
    key = player_input.keys[0]
    self.word[player_input[key]] = self.word.delete key
  end

  def update_choices
    self.word.keys.select { |key| key.instance_of?(Integer) }
  end

  def update_life
    self.player.life += 1
  end

  def stop_conditions_met
    quit || guessed || no_turns_left
  end

  def report_end_terms
    if quit
      display_quit_message
    elsif guessed
      display_guessed_message
    elsif no_turns_left
      display_no_turns_left_message
    end

    puts self.word.values.join
  end

  def quit(quit_prompt = 'n')
    # quit_prompt == 'q'
    return true if quit_prompt == 'q'

    false
  end

  def guessed
    true if self.word.keys == self.word.values
  end

  def no_turns_left
    return true if self.player.life == 5
    false
  end
end
