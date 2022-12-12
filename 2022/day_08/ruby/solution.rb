require "matrix"

class Solution
  def part1
    matrix_transposed = matrix.transpose

    size = matrix.first.length - 1

    left_right = []
    top_bottom = []

    matrix.size.times do |index|
      left_right << visible(matrix[index])
      top_bottom << visible(matrix_transposed[index])
    end

    top_bottom = top_bottom.transpose

    result = left_right.zip(top_bottom).map do |row|
      or_arrays(row.first, row.last)
    end

    puts "*" * 100
    puts "visible: #{count_true(result)}"
    puts "*" * 100
  end

  def part2
    matrix_transposed = matrix.transpose

    size = matrix.first.length - 1

    left = []
    right = []
    top = []
    bottom = []

    matrix.size.times do |index|
      left << distances(matrix[index].reverse).reverse
      right << distances(matrix[index])
      top << distances(matrix_transposed[index].reverse).reverse
      bottom << distances(matrix_transposed[index])
    end

    top = top.transpose
    bottom = bottom.transpose

    scenic_scores = []

    top.each_with_index do |row, row_index|
      scores = []

      row.each_with_index do |element, col_index|
        scores << element * left[row_index][col_index] * right[row_index][col_index] * bottom[row_index][col_index]
      end

      scenic_scores << scores.max
    end

    puts "*" * 100
    puts "scenic score: #{scenic_scores.max}"
    puts "*" * 100
  end

  private

  def input_file_name
    @input_file_name ||= 'input.txt'
  end

  def input
    @input ||= File.read(File.join(File.dirname(__FILE__), '..', input_file_name))
  end

  def matrix
    @matrix ||= begin
      matrix = []

      input.each_line do |line|
        matrix << line.strip.chars.map(&:to_i)
      end

      matrix
    end
  end

  def print_matrix(m)
    puts "*" * 100

    m.each do |row|
      puts row.inspect
    end

    puts "*" * 100
  end

  def visible(row)
    forward = visible_elements(row)
    reversed = visible_elements(row.reverse).reverse

    or_arrays(forward, reversed)
  end

  def visible_elements(row)
    max = -1
    results = []

    row.each_with_index do |element, index|
      if element > max
        results << true
        max = element
      else
        results << false
      end
    end

    results
  end

  def or_arrays(array, *other_arrays)
    array.zip(*other_arrays).map do |column|
      column.reduce do |result, element|
        result || element
      end
    end
  end

  def count_true(matrix)
    matrix.flatten.count(true)
  end

  def distances(input)
    # Input is an array of integers
    distances = []

    # for each element, count how many elements are smaller to the right
    input.each_with_index do |element, index|
      # start count at 1 to ensure last element in array will always have distance of 1
      count = 1

      while (index + count < input.size - 1) && (input[index + count] < element)
        count += 1
      end

      distances << count
    end

    distances
  end
end

Solution.new.part1 # 1798
Solution.new.part2 # 259308
