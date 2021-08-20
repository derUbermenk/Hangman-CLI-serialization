require 'yaml'
require_relative 'game'
require_relative 'display'

class Main
  include Display
  def run
    display_initial_user_prompt
    user_input = gets.chomp

    game = load_game if user_input == 'l'
    game = new_game if user_input == 'n'

    game.play
  end

  def load_game
    saves = acquire_saves
    display_all_saves(saves)

    save_name = saves[input_save_num(saves)]
    YAML.load(File.read("saves/#{save_name}"))
  end

  def input_save_num(saves)
    display_choose_saves
    begin
      save_num = gets.chomp.to_i
    rescue
      display_invalid_input
      input_save_num
    end

    save_num
  end

  def new_game
    Game.new
  end

  # @return [Hash]
  def acquire_saves
    saves = Dir["./saves/*.yml"]
    item_count = 0
    saves.each_with_object({}) do |item, hash|
      hash[item_count] = item.split('/')[2]
      item_count += 1
    end
  end
end

main = Main.new
main.run
