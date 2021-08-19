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
    display_choose_saves
    save_num = gets.chomp

    unless correct_input(save_num)
      display_invalid_input_group
      save_num = gets.chomp
    end

    save_name = saves[save_num]
    YAML.load(File.read("saves/#{save_name}"))
  end

  def new_game
    Game.new
  end

  def acquire_saves
    saves = Dir['./saves/*.rb'].split('/')[2]
    item_count = 0
    saves.each_with_object({}) do |item, hash|
      hash[i] = item
      item_count += 1
    end
  end
end

main = Main.new
main.run
