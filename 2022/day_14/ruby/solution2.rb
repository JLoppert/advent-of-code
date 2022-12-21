class Solution2
  AIR = "."
  ROCK = "#"
  SAND = "o"
  SOURCE = "+"

  def initialize
    parse_scan
  end

  def part2
    @grid = Grid.new(@walls, floor: true)
    # source point (500, 0) -- row 0, column 500
    # reduce column by column_min to get the correct column index
    # @grid.source_point = Point.new(0, 0, SOURCE)
    # @grid.source_point = Point.new(0, 500 - @grid.column_min, SOURCE)
    lambda = ->(current_point) do
      point_below = @grid.point_at(*current_point.below)
      point_diagonal_left = @grid.point_at(*current_point.diagonal_left)
      point_diagonal_right = @grid.point_at(*current_point.diagonal_right)

      current_point == @grid.source_point &&
        point_below.sand? && point_diagonal_left.sand? &&
          point_diagonal_right.sand?
    end

    puts @grid.to_s

    until @grid.done
    # 10.times do
      @grid.produce_sand!(end_condition: lambda)
    end

    puts @grid.to_s

    puts "*" * 100
    puts "Sand count: #{@grid.sand_count}"
    puts "*" * 100
  end

  private

  def input_file_name
    @input_file_name ||= 'test_input.txt'
    # @input_file_name ||= 'input.txt'
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

  # This is dumb and should be removed
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

    def sand?
      @state == SAND
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

    def inspect
      "point: (#{@row}, #{@column})"
    end
  end

  class Grid
    attr_accessor :source_point, :column_min, :done, :sand_count, :row_count, :column_count

    def initialize(walls, floor: false)
      @walls = walls

      @done = false
      @sand_count = 0

      row_max, column_max, @column_min = grid_bounds(walls)

      if floor
        row_max += 2
      end

      @row_count = row_max + 1
      column_count_old = column_max - @column_min
      @column_count = 2 * (@row_count) + 1

      @old_center = column_count_old / 2
      new_center = @column_count / 2
      @column_offset = new_center - @old_center

      # row_max + 1 because want to index into @grid[row_max]
      @grid = Array.new(@row_count) do |row|
        state = row == @row_count - 1 ? ROCK : AIR

        Array.new(@column_count) do |column|
          Point.new(row, column, state)
        end
      end

      @source_point = Point.new(0, new_center, SOURCE)
      @grid[@source_point.row][@source_point.column] = @source_point

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

      @grid[row][column + @column_offset] = point
    end

    def set_sand(point)
      point.update!(SAND)
      @sand_count += 1
    end

    def produce_sand!(end_condition:)
      current_point = point_at(@source_point.row, @source_point.column)

      loop do
        if end_condition.call(current_point)
          set_sand(current_point)
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
          set_sand(current_point)
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

      # Not really sure why + 5 works, but it does
      magic_offset = 5 # when input.txt
      # magic_offset = 2 # when test_input.txt
      [point.row, point.column - @column_min - @old_center + magic_offset]
    end

    def to_s
      @grid.map do |row|
        row.join('')
      end.join("\n")
    end
  end
end

Solution2.new.part2 # 29076
