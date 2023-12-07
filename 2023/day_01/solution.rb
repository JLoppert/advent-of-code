require 'set'

class Solution
  # What is the sum of all of the calibration values?
  def part1
    @set = Set.new
    ("1".."9").to_a.each do |digit|
      @set.add(digit)
    end

    File.open('input.txt', 'r') do |file|
      calibration_values = []

      file.each_line do |line|
        line.strip!

        calibration_values << (first_digit(line) + first_digit(line.reverse)).to_i
      end

      puts calibration_values.reduce(:+)
    end
  end

  def part2
    @set = Set.new

    @alpha = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    @alpha_reverse = @alpha.collect { |word| word.reverse }
    numeric = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

    (@alpha + numeric).each { |digit| @set.add(digit) }

    lines = []
    calibration_values = []

    File.open('input.txt', 'r') do |file|
      calibration_values = []

      file.each_line do |line|
        line.strip!

        calibration_values << (first_digit_word(line) * 10) + first_digit_word(line, reverse: true)
        lines << line
      end
    end

    puts calibration_values.reduce(:+)
  end

  private

  def first_digit(line)
    line.chars do |char|
      if @set.include?(char)
        return char
      end
    end
  end

  def first_digit_word(line, reverse: false)
    indicies = {}

    if reverse
      line = line.reverse
    end

    @set.each do |digit|
      if reverse
        digit = digit.reverse
      end

      index = line.index(digit)

      if !index.nil?
        indicies[index] = to_i(digit)
      end
    end

    indicies[indicies.keys.min]
  end

  def to_i(digit)
    if digit.size > 1
      if @alpha.include?(digit)
        @alpha.index(digit) + 1
      else
        @alpha_reverse.index(digit) + 1
      end
    else
      digit.to_i
    end
  end
end

Solution.new.part1
Solution.new.part2
