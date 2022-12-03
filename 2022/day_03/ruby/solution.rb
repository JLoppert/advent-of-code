class Solution
  def part1
    priority_sum = 0

    input.each_line do |rucksack|
      compartments = partition(rucksack.strip).map(&:chars)
      common_item = common_item_from(compartments)
      priority = priority(common_item)

      priority_sum += priority
    end

    puts "*" * 100
    puts "priority_sum = #{priority_sum}"
    puts "*" * 100
  end

  def part2
    priority_sum = 0
    elves = []

    input.each_line.with_index do |rucksack, index|
      elves << rucksack

      if (index + 1) % 3 == 0
        elves = elves.map { |rucksack| rucksack.strip.chars }
        common_item = common_item_from(elves)
        priority = priority(common_item)

        priority_sum += priority
        elves = []
      else
        next
      end
    end

    puts "*" * 100
    puts "priority_sum = #{priority_sum}"
    puts "*" * 100
  end

  private

  def input
    @input ||= File.read(File.join(File.dirname(__FILE__), '..', 'input.txt'))
  end

  def partition(rucksack)
    index = (rucksack.length / 2)
    first = rucksack[0..index - 1]
    second = rucksack[index..-1]

    [first, second]
  end

  def common_item_from(rucksacks)
    rucksacks.reduce do |first, second|
      first & second
    end.first
  end

  def priority(char)
    char_value = char.ord

    if is_upper?(char_value)
      char_value - 'A'.ord + 27
    else
      char_value - 'a'.ord + 1
    end
  end

  def is_upper?(char_value)
    char_value >= 'A'.ord && char_value <= 'Z'.ord
  end
end

solution = Solution.new
Solution.new.part1
Solution.new.part2
