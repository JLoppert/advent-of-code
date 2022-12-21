class Solution1
  AIR = "."
  ROCK = "#"
  SAND = "o"
  SOURCE = "+"

  def initialize
    parse_scan
    @grid = Grid.new(@walls)
  end

  def part1
    # source point (500, 0) -- row 0, column 500
    # reduce column by column_min to get the correct column index
    @grid.source_point = Point.new(0, 500 - @grid.column_min, SOURCE)

    until @grid.done
      @grid.produce_sand!
    end

    # puts @grid.to_s

    puts "*" * 100
    puts "Sand count: #{@grid.sand_count}"
    puts "*" * 100
  end

  private

  def input_file_name
    # @input_file_name ||= 'test_input.txt'
    @input_file_name ||= 'input.txt'
  end

  def input
    @input ||= File.open(File.join(File.dirname(__FILE__), '..', input_file_name))
  end

  def parse_scan
    @walls = []

    @row_max, @row_min = [0, 1_000]
    @column_max, @column_min = [0, 1_000]

    input.each_line do |line|
      points = line.strip.split(' -> ').map do |point|
        # input: (x,y)
        #   x = distance to the right (column)
        #   y = distance down (row)
        column, row = point.split(',').map(&:to_i)

        [row, column]
      end

      p1_idx = 0
      p2_idx = 1

      loop do
        if p2_idx == points.size
          break
        end

        p1 = points[p1_idx]
        p2 = points[p2_idx]

        @walls << Wall.new(p1, p2)

        p1_idx += 1
        p2_idx += 1
      end
    end
  end

  class Wall
    attr_reader :row_max, :column_min, :column_max

    # p1 = [row, column]
    # p2 = [row, column]
    def initialize(p1, p2)
      @p1 = p1
      @p2 = p2

      row = [@p1.first, @p2.first]
      column = [@p1.last, @p2.last]

      @row_max = row.max
      @row_min = row.min
      @column_max = column.max
      @column_min = column.min

      @row_range = @row_min..@row_max
      @column_range = @column_min..@column_max
    end

    def points
      @points ||= begin
        # Horizontal wall
        if @p1.first == @p2.first
          @column_range.map do |column|
            Point.new(@p1.first, column, ROCK)
          end
        else # Vertical wall
          @row_range.map do |row|
            Point.new(row, @p1.last, ROCK)
          end
        end
      end
    end

    def to_s
      "#{@p1.inspect} -> #{@p2.inspect}"
    end
  end

  class Point
    attr_reader :row, :column, :state

    def initialize(row, column, state = AIR)
      @row = row
      @column = column
      @state = state
    end

    def air?
      @state == AIR
    end

    def update!(state)
      @state = state
    end

    def below
      [@row + 1, @column]
    end

    def diagonal_left
      [@row + 1, @column - 1]
    end

    def diagonal_right
      [@row + 1, @column + 1]
    end

    def to_s
      @state
    end
  end

  class Grid
    attr_accessor :source_point, :column_min, :done, :sand_count

    def initialize(walls)
      @walls = walls

      @done = false
      @source_point = nil
      @sand_count = 0

      row_max, column_max, @column_min = grid_bounds(walls)

      @row_count = row_max + 1
      @column_count = (column_max - @column_min) + 1

      # row_max + 1 because want to index into @grid[row_max]
      @grid = Array.new(@row_count) do |row|
        Array.new(@column_count) do |column|
          Point.new(row, column)
        end
      end

      @walls.each do |wall|
        wall.points.each do |point|
          set_point!(point)
        end
      end
    end

    def grid_bounds(walls)
      row_max = 0
      column_max = 0
      column_min = Float::INFINITY

      walls.each do |wall|
        row_max = wall.row_max if wall.row_max > row_max
        column_max = wall.column_max if wall.column_max > column_max
        column_min = wall.column_min if wall.column_min < column_min
      end

      [row_max, column_max, column_min]
    end

    def set_point!(point)
      row, column = indicies_for(point)

      @grid[row][column] = point
    end

    def produce_sand!
      current_point = @source_point

      loop do
        if current_point.row + 1 >= @row_count ||
            current_point.column + 1 > @column_count ||
              current_point.column - 1 < 0
          @done = true
          return
        end

        point_below = point_at(*current_point.below)
        point_diagonal_left = point_at(*current_point.diagonal_left)
        point_diagonal_right = point_at(*current_point.diagonal_right)

        if point_below.air?
          current_point = point_below
        elsif point_diagonal_left.air?
          current_point = point_diagonal_left
        elsif point_diagonal_right.air?
          current_point = point_diagonal_right
        else
          current_point.update!(SAND)
          @sand_count += 1
          return
        end
      end
    end

    def point_at(row, column)
      @grid[row][column]
    end

    def indicies_for(point)
      # row is 0 - row value
      # column is column_min value (0) to column_max value - 1 (colmn - column_min - 1)
      [point.row, point.column - @column_min]
    end

    def to_s
      @grid.map do |row|
        row.join('')
      end.join("\n")
    end
  end
end

Solution1.new.part1 # 799
