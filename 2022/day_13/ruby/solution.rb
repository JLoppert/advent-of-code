require 'json'

class Solution
  def part1
    parse_pairs

    sum = 0

    @pairs.each_with_index do |pair, index|
      if pair.ordered?
        sum += index + 1
      end
    end

    puts "*" * 100
    puts "Ordered sum: #{sum}"
    puts "*" * 100
  end

  def part2
    parse_signals

    # dividers
    d1 = Signal.new("[[2]]")
    d2 = Signal.new("[[6]]")

    # add dividers to signals
    @signals += [d1, d2]

    # sort signals
    @signals.sort!

    # find dividers in sorted signals
    # index returns 0 based, so add 1
    d1_index = @signals.index(d1) + 1
    d2_index = @signals.index(d2) + 1

    puts "*" * 100
    puts "Decoder Key: #{d1_index * d2_index}"
    puts "*" * 100
  end

  private

  def input_file_name
    @input_file_name ||= 'input.txt'
  end

  def input
    @input ||= File.open(File.join(File.dirname(__FILE__), '..', input_file_name))
  end

  def parse_pairs
    @pairs = []
    count = 1

    input.each_slice(3) do |line|
      @pairs << Pair.new(line[0].strip, line[1].strip)
    end
  end

  def parse_signals
    @signals = []
    count = 1

    input.each_line do |line|
      line = line.strip

      if line.empty?
        next
      end

      @signals << Signal.new(line)
    end
  end

  class Pair
    def initialize(left, right)
      @left = Signal.new(left)
      @right = Signal.new(right)
    end

    def ordered?
      (@left <=> @right) == -1
    end

    def to_s
      puts "Left: #{@left.value.inspect}"
      puts "Right: #{@right.value.inspect}"
    end
  end

  class Signal
    attr_reader :value

    def initialize(value)
      @value = JSON.parse(value)
    end

    def to_s
      @value.inspect
    end

    def <=>(other)
      compare(self.value, other.value)
    end

    def compare(left, right)
      case [left.class, right.class]
      when [Array, Array]
        compare_array(left, right)
      when [Array, Integer]
        compare_array(left, [right])
      when [Integer,  Array]
        compare_array([left], right)
      else
        left <=> right
      end
    end

    def compare_array(left, right)
      i = 0

      loop do
        # left ran out first
        if left[i].nil? && right[i]
          # items are in correct order
          return -1
        end

        # right ran out first
        if left[i] && right[i].nil?
          # items are not in correct order
          return 1
        end

        # both ran out
        if left[i].nil? && right[i].nil?
          return 0
        end

        comparison = compare(left[i], right[i])

        if comparison != 0
          return comparison
        end

        i += 1
      end
    end
  end
end

# Solution.new.part1 # 5843
Solution.new.part2
