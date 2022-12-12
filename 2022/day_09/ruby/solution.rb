require "set"

class Solution
  def part1
    @snake = Snake.new

    process_input

    puts "*" * 100
    puts "visited: #{@snake.visited.size}"
    puts "*" * 100
  end

  def part2
    @snake = Snake.new(size: 10)

    process_input

    puts "*" * 100
    puts "visited: #{@snake.visited.size}"
    puts "*" * 100
  end

  private

  def input_file_name
    @input_file_name ||= 'input.txt'
  end

  def input
    @input ||= File.read(File.join(File.dirname(__FILE__), '..', input_file_name))
  end

  def process_input
    input.each_line do |line|
      direction, distance = line.strip.split(' ')
      distance = distance.to_i

      distance.times do
        @snake.move!(direction)
      end
    end
  end

  class Snake
    attr_reader :segments, :head, :tail, :visited

    def initialize(size: 2)
      @segments = Array.new(size) { Point.new }

      @head = @segments.first
      @tail = @segments.last

      @visited = Set.new
      @visited.add(@tail.to_a)
    end

    def move!(direction)
      # always move the first segment
      head.move!(direction)

      # update the remaining segments
      segments[1..-1].each_with_index do |segment, index|
        previous_segment = segments[index]

        if previous_segment.distance(segment) >= 2
          segment.update!(**previous_segment.delta(segment))

          # moving the tail to a new position
          if segment == tail
            visited.add(tail.to_a)
          end
        end
      end
    end
  end

  class Point
    attr_reader :x, :y

    def initialize(x: 0, y: 0)
      @x = x
      @y = y
    end

    def update!(x: 0, y: 0)
      @x += x
      @y += y
    end

    def move!(direction)
      case direction
      when 'U'
        update!(y: 1)
      when 'D'
        update!(y: -1)
      when 'L'
        update!(x: -1)
      when 'R'
        update!(x: 1)
      end
    end

    # c = sqrt(a^2 + b^2)
    def distance(other)
      a_squared = (@x - other.x) ** 2
      b_squared = (@y - other.y) ** 2

      Math.sqrt(a_squared + b_squared)
    end

    def delta(other)
      {
        x: convert(@x - other.x),
        y: convert(@y - other.y)
      }
    end

    def to_a
      [@x, @y]
    end

    private

    # if input is 2, return 1 of the corresponding sign
    # otherwise return the original input ex (-1, 0, 1)
    def convert(input)
      case input
      when 2 then 1
      when -2 then -1
      else input
      end
    end
  end
end

Solution.new.part1 # 6023
Solution.new.part2 # 2533
