class Solution
  def part1
    answer = 0

    input.each_line do |assignment|
      elf1, elf2 = assignment.strip.split(",")

      elf1_range = to_range(elf1)
      elf2_range = to_range(elf2)

      if elf1_range.cover?(elf2_range) || elf2_range.cover?(elf1_range)
        answer += 1
      end
    end

    puts "*" * 100
    puts "answer = #{answer}"
    puts "*" * 100
  end

  def part2
    answer = 0

    input.each_line do |assignment|
      elf1, elf2 = assignment.strip.split(",")

      elf1_array = to_range(elf1).to_a
      elf2_array = to_range(elf2).to_a

      unless elf1_array.intersection(elf2_array).empty?
        answer += 1
      end
    end

    puts "*" * 100
    puts "answer = #{answer}"
    puts "*" * 100
  end

  private

  def input
    @input ||= File.read(File.join(File.dirname(__FILE__), '..', 'input.txt'))
  end

  def to_range(section)
    first, second = section.split('-')

    (first.to_i)..(second.to_i)
  end
end

solution = Solution.new
solution.part1
solution.part2
