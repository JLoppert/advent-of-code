class Solution
  def part1
    valid_games = 0

    File.open('input.txt', 'r') do |file|
      file.each_line.with_index do |line, index|
        line.strip!

        if Game.new(line).valid?
          valid_games += (index + 1)
        end
      end

      puts valid_games
    end
  end

  def part2
    games_power = 0

    File.open('input.txt', 'r') do |file|
      file.each_line.with_index do |line, index|
        line.strip!

        games_power += Game.new(line).power
      end

      puts games_power
    end
  end
end

class Game
  RED = 12
  GREEN = 13
  BLUE = 14

  def initialize(line)
    @line = line
    @red = 0
    @green = 0
    @blue = 0

    parse!
  end

  def parse!
    @line.sub!(/Game \d+: /, '')

    sets = @line.split(";").each do |set|
      set.split(",").each do |color|
        count, color = color.split(" ")
        count = count.to_i

        case color
        when "red"
          @red = [@red, count].max
        when "green"
          @green = [@green, count].max
        when "blue"
          @blue = [@blue, count].max
        end
      end
    end
  end

  def valid?
    @red <= RED && @green <= GREEN && @blue <= BLUE
  end

  def power
    @red * @green * @blue
  end

  def to_s
    "red: #{@red}, green: #{@green}, blue: #{@blue}"
  end
end

Solution.new.part1
Solution.new.part2
