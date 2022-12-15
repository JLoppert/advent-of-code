class Solution
  START_VALUE = -1
  END_VALUE = 26

  def part1
    puts "*" * 100
    puts "Min traversal: #{height_map.breadth_first_search(height_map.start)}"
    puts "*" * 100
  end

  def part2
    # get all starting points
    starting_points = height_map.rows.map do |row|
      row.select(&:starting_point?)
    end.flatten

    # prune vertices that are only connected to other starting points
    prune_index = 0
    while prune_index < starting_points.length
      if starting_points[prune_index].edges.all? { |vertex| vertex.starting_point? }
        starting_points.delete_at(prune_index)
      else
        prune_index += 1
      end
    end

    traversals = starting_points.map do |vertex|
      # ensure all vertices have visiting value set to false
      height_map.reset!
      height_map.breadth_first_search(vertex)
    end

    puts "*" * 100
    puts "Min traversal: #{traversals.min}"
    puts "*" * 100
  end

  private

  def input_file_name
    @input_file_name ||= 'input.txt'
  end

  def input
    @input ||= File.open(File.join(File.dirname(__FILE__), '..', input_file_name))
  end

  def height_map
    @height_map ||= Graph.new(input)
  end

  class Vertex
    attr_reader :value, :edges

    def initialize(value, row, column)
      @value = value
      @row = row
      @column = column

      @edges = []
      @visited = false
    end

    def can_reach?(other_vertex)
      other_vertex.value <= @value || other_vertex.value - @value == 1
    end

    def finished?
      @value == END_VALUE
    end

    def starting_point?
      @value == START_VALUE || @value == 0
    end

    def visited?
      @visited
    end

    def visit!
      @visited = true
    end

    def reset!
      @visited = false
    end

    def add_edge(other_vertex)
      @edges << other_vertex
    end
  end

  class Graph
    attr_reader :rows, :start, :end

    def initialize(input)
      @input = input

      @rows = []
      @start = nil
      @end = nil

      parse_input
      connect_edges
    end

    def reset!
      @rows.each do |row|
        row.each do |vertex|
          vertex.reset!
        end
      end
    end

    def breadth_first_search(start)
      count = 0
      visiting = [start]

      while visiting
        next_visiting = []

        visiting.each do |vertex|
          return count if vertex.finished?

          vertex.visit!

          next_visiting += vertex.edges.reject(&:visited?)
        end

        visiting = next_visiting.uniq
        count += 1
      end
    end

    private

    def connect_edges
      @rows.each_with_index do |row, row_index|
        row.each_with_index do |vertex, col_index|
          # add edge to vertex if value in direction is exactly 1 greater

          # bottom
          if row_index < @rows.length - 1 && vertex.can_reach?(@rows[row_index + 1][col_index])
            vertex.add_edge(@rows[row_index + 1][col_index])
          end

          # right
          if col_index < row.length - 1 && vertex.can_reach?(@rows[row_index][col_index + 1])
            vertex.add_edge(@rows[row_index][col_index + 1])
          end

          # top
          if 0 < row_index && vertex.can_reach?(@rows[row_index - 1][col_index])
            vertex.add_edge(@rows[row_index - 1][col_index])
          end

          # left
          if 0 < col_index && vertex.can_reach?(@rows[row_index][col_index - 1])
            vertex.add_edge(@rows[row_index][col_index - 1])
          end
        end
      end
    end

    def parse_input
      a_ord = 'a'.ord

      @input.each_line.with_index do |line, row_index|
        row = []
        line.strip!

        line.chars.each_with_index do |char, col_index|
          char_ord = char.ord

          row << if char == "S"
            @start = Vertex.new(START_VALUE, row_index, col_index)
          elsif char == "E"
            @end = Vertex.new(END_VALUE, row_index, col_index)
          else
            Vertex.new(char_ord - a_ord, row_index, col_index)
          end
        end

        @rows << row
      end
    end
  end
end

Solution.new.part1 # 380
Solution.new.part2 # 375
