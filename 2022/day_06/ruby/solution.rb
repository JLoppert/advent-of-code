class Solution
  def part1
    buffer_length = 4

    buffer_position(input, buffer_length)
  end

  def part2
    buffer_length = 14

    buffer_position(input, buffer_length)
  end

  def part1_test_cases
    buffer_length = 4

    puts buffer_position('bvwbjplbgvbhsrlpgdmjqwftvncz', buffer_length) == 5
    puts buffer_position('nppdvjthqldpwncqszvftbrmjlhg', buffer_length) == 6
    puts buffer_position('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg', buffer_length) == 10
    puts buffer_position('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw', buffer_length) == 11
  end

  def part2_test_cases
    buffer_length = 14

    puts buffer_position("mjqjpqmgbljsphdztnvjfqwrcgsmlb", buffer_length) == 19
    puts buffer_position("bvwbjplbgvbhsrlpgdmjqwftvncz", buffer_length) == 23
    puts buffer_position("nppdvjthqldpwncqszvftbrmjlhg", buffer_length) == 23
    puts buffer_position("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", buffer_length) == 29
    puts buffer_position("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", buffer_length) == 26
  end

  private

  def input
    @input ||= File.read(File.join(File.dirname(__FILE__), '..', 'input.txt'))
  end

  def buffer_position(datastream, buffer_length)
    buffer = []

    datastream.chars.each.with_index do |buffer_char, index|
      if buffer.length == buffer_length
        buffer.shift
        buffer.push(buffer_char)

        if buffer.uniq.length == buffer_length
          puts "*" * 100
          puts "buffer: #{buffer}, index: #{index + 1}"
          puts "*" * 100
          return index + 1
        end
      else
        buffer.push(buffer_char)
      end
    end
  end
end

solution = Solution.new
# solution.part1_test_cases
solution.part1

# solution.part2_test_cases
solution.part2
