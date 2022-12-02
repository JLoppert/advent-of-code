class Solution
  # Find the Elf carrying the most Calories. How many total Calories is that Elf carrying?
  def part1
    max_calories = 0
    current_calories = 0
    elf = 1

    File.open('input.txt', 'r') do |file|
      file.each_line do |line|
        if line == "\n"
          puts "max = #{max_calories}, current = #{current_calories} elf = #{elf}"

          if max_calories < current_calories
            max_calories = current_calories

          end

          elf += 1
          current_calories = 0
        else
          current_calories += line.to_i
        end
      end

      puts "*" * 100
      puts "max = #{max_calories}"
      puts "*" * 100
    end
  end

  # Find the top three Elves carrying the most Calories. How many Calories are those Elves carrying in total?
  def part2
    top_elves_calories = []
    min_calories = 0
    current_calories = 0

    File.open('input.txt', 'r') do |file|
      file.each_line do |line|
        if line == "\n"
          puts "max = #{top_elves_calories}, min = #{min_calories} current = #{current_calories}"

          if top_elves_calories.length < 3
            top_elves_calories << current_calories
            min_calories = top_elves_calories.min
          elsif min_calories < current_calories
            top_elves_calories.delete(min_calories)
            top_elves_calories << current_calories
            min_calories = top_elves_calories.min
          end

          current_calories = 0
        else
          current_calories += line.to_i
        end
      end

      puts "*" * 100
      puts "top_elves_calories = #{top_elves_calories.sort}"
      puts "top_elves_calories = #{top_elves_calories.sum}"
      puts "*" * 100
    end
  end
end

Solution.new.part1
Solution.new.part2
