require 'pry-byebug'
require 'yaml'
require_relative 'display'
require_relative 'player'
require_relative 'evaluator'

class Game
  include Display

  attr_accessor :evaluator, :player,
                :word, :choices, :quit_condition

  def initialize
    @evaluator = Evaluator.new
    @player = Player.new
    @word = nil
    @choices = nil
    @quit_condition = nil
  end

  def play
    generate_word if word.nil?
    display_guess_status(self.word, self.player.life)
    keep_playing until stop_conditions_met

    report_end_terms
  end

  private

  def generate_word
    self.word = evaluator.make_word
    self.choices = self.word.keys

    p self.word
  end

  def keep_playing
    puts "\n"
    player_input = player.guess(self.choices)
    input_key = player_input.keys[0]
    p input_key
    case input_key
    when 's' then save
    when 'q' then quit('q')
    else
      evaluate_guess(player_input)
    end
  end

  def save
    # save current game
    Dir.mkdir('saves') unless Dir.exist?('saves')

    display_save_name_prompt
    save_name = "#{gets.chomp}.yml"
    File.open("saves/#{save_name}", 'w') { |file| file.write(self.to_yaml) }
    display_game_saved
  end

  def name_valid(name)
    name = name.split
    space = ' '
    number = /\d/

    name.include?(space) || !name[number].nil?
  end

  def evaluate_guess(player_input)
    puts "\n"
    guess_acc = evaluator.evaluate(player_input, self.word)
    update_word(player_input) if guess_acc == true
    update_choices
    update_life if guess_acc == false
    display_guess_status(self.word, self.player.life)
  end

  def update_word(player_input)
    key = player_input.keys[0]
    self.word.transform_keys! do |hash_key|
      hash_key == key ? player_input[key] : hash_key
    end
  end

  def update_choices
    self.word.keys.select { |key| key.instance_of?(Integer) }
  end

  def update_life
    self.player.life += 1
  end

  def stop_conditions_met
    self.quit_condition || guessed || no_turns_left
  end

  def report_end_terms
    if self.quit_condition 
      display_quit_message
    elsif guessed
      display_guessed_message
    elsif no_turns_left
      display_no_turns_left_message
    end

    puts self.word.values.join
  end

  def quit(quit_prompt = 'n')
    self.quit_condition = true if quit_prompt == 'q'
  end

  def guessed
    true if self.word.keys == self.word.values
  end

  def no_turns_left
    return true if self.player.life == 5
    false
  end
end
