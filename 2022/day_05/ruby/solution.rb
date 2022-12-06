class Solution
  def part1
    input.each_line do |line|
      if line.start_with?("move")
        count, from, to = parse_move(line)

        crates = pop_crates(count, from)
        push_crates(crates.reverse, to)
      end
    end

    top_crates
  end

  def part2
    input.each_line do |line|
      if line.start_with?("move")
        count, from, to = parse_move(line)

        crates = pop_crates(count, from)
        push_crates(crates, to)
      end
    end

    top_crates
  end

  private

  def input
    @input ||= File.read(File.join(File.dirname(__FILE__), '..', 'input.txt'))
  end

  def stacks
    @stacks ||= [
      ["B", "Z", "T"],
      ["V", "H", "T", "D", "N"],
      ["B", "F", "M", "D"],
      ["T", "J", "G", "W", "V", "Q", "L"],
      ["W", "D", "G", "P", "V", "F", "Q", "M"],
      ["V", "Z", "Q", "G", "H", "F", "S"],
      ["Z", "S", "N", "R", "L", "T", "C", "W"],
      ["Z", "H", "W", "D", "J", "N", "R", "M"],
      ["M", "Q", "L", "F", "D", "S"],
    ]
  end

  def parse_move(move)
    regex = /move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)\n?/
    match_data = move.match(regex)

    [
      match_data[:count].to_i,
      match_data[:from].to_i - 1,
      match_data[:to].to_i - 1
    ]
  end

  def pop_crates(count, from)
    stacks[from].pop(count)
  end

  def push_crates(crates, to)
    stacks[to].concat(crates)
  end

  def top_crates
    crates = ""

    stacks.each do |stack|
      crates += stack.last
    end

    puts "*" * 100
    puts "top crates = #{crates}"
    puts "*" * 100
  end

  def print_stacks
    stacks.each do |stack|
      puts stack.inspect
    end

    puts "*" * 100
  end
end

solution = Solution.new
solution.part1

solution = Solution.new
solution.part2
