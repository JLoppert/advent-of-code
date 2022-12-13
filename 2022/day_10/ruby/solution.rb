class Solution
  def part1
    process_input1

    puts "*" * 100
    puts "signal strenght: #{cpu.total_signal_strength}"
    puts "*" * 100
  end

  def part2
    process_input2

    puts "*" * 100
    crt.pretty_print
    puts "*" * 100
  end

  private

  def input_file_name
    @input_file_name ||= 'input.txt'
  end

  def input
    @input ||= Input.new(file_name: input_file_name)
  end

  def cpu
    @cpu ||= CPU.new
  end

  def crt
    @crt ||= CRT.new(cpu: cpu)
  end

  def process_input1
    line = input.next_line
    cpu.increment_cycle!

    loop do
      if line.nil?
        break
      end

      if cpu.interesting_cycle?
        cpu.add_signal_strength!
      end

      if line == "noop"
        line = input.next_line
      elsif cpu.can_add?
        value = line.split(' ').last.to_i

        cpu.add!(value)

        line = input.next_line
      else
        cpu.decrement_counter!
      end

      cpu.increment_cycle!
    end
  end

  def process_input2
    line = input.next_line

    loop do
      if line.nil?
        break
      end

      crt.update!

      if line == "noop"
        line = input.next_line
      elsif cpu.can_add?
        value = line.split(' ').last.to_i

        cpu.add!(value)

        line = input.next_line
      else
        cpu.decrement_counter!
      end

      cpu.increment_cycle!
    end
  end

  class Input
    def initialize(file_name:)
      @enumerator = File.read(File.join(File.dirname(__FILE__), '..', file_name)).each_line
    end

    def next_line
      @enumerator.next.strip
    rescue StopIteration
      nil
    end
  end

  class CPU
    attr_reader :cycle, :register, :counter, :total_signal_strength

    def initialize
      @register = 1
      @cycle = 0
      @total_signal_strength = 0

      reset_counter!
    end

    def increment_cycle!
      @cycle += 1
    end

    def add!(value)
      @register += value

      reset_counter!
    end

    def can_add?
      @counter.zero?
    end

    def decrement_counter!
      @counter -= 1
    end

    def reset_counter!
      @counter = 1
    end

    def signal_strength
      @register * @cycle
    end

    def interesting_cycle?
      (cycle - 20) % 40 == 0
    end

    def add_signal_strength!
      @total_signal_strength += signal_strength
    end
  end

  class CRT
    DARK = "."
    LIT = "#"
    WIDTH = 40
    HEIGHT = 6

    def initialize(cpu:)
      @cpu = cpu
      @pixels = Array.new(HEIGHT) { Array.new(WIDTH) { DARK } }
    end

    def pretty_print
      @pixels.each do |row|
        puts row.join
      end

      nil
    end

    def sprite_position
      @cpu.register
    end

    def cycle
      @cpu.cycle
    end

    def coordinates_for(position)
      row = position / WIDTH
      column = position % WIDTH

      [row, column]
    end

    def lit?(column)
      sprite_start = sprite_position - 1
      sprite_end = sprite_position + 1
      range = sprite_start..sprite_end

      range.cover?(column)
    end

    def update!
      cycle_row, cycle_column = coordinates_for(cycle)

      @pixels[cycle_row][cycle_column] = lit?(cycle_column) ? LIT : DARK

      # puts "Current CRT Row: #{@pixels[cycle_row][0..cycle_column].join}"
    end

    def draw_sprite
      arr = Array.new(WIDTH) { DARK }

      arr[sprite_position - 1] = LIT
      arr[sprite_position] = LIT
      arr[sprite_position + 1] = LIT

      # puts "Sprite position: #{arr.join}"
    end
  end
end

Solution.new.part1 # 11780
Solution.new.part2 # PZULBAUA
