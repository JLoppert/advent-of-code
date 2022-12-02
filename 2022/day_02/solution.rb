class Solution
  # Rock     = A || X
  # Paper    = B || Y
  # Scissors = C || Z

  # Rock > Scissors (A, X) > (C, Z)
  # Paper > Rock (B, Y) > (A, X)
  # Scissors > Paper (C, Z) > (B, Y)

  # Scoring = Symbol + Result

  # Rock     = 1
  # Paper    = 2
  # Scissors = 3

  # Loss = 0 pts
  # Tie  = 3 pts
  # Win  = 6 pts
  def part1
    rock = 1
    paper = 2
    scissors = 3

    win = 6
    tie = 3
    loss = 0

    matrix = {
      "X" => { "A" => rock + tie, "B" => rock + loss, "C" => rock + win },
      "Y" => { "A" => paper + win, "B" => paper + tie, "C" => paper + loss },
      "Z" => { "A" => scissors + loss, "B" => scissors + win, "C" => scissors + tie },
    }

    score = 0

    File.readlines('input.txt').each do |line|
      opponent, strategy = line.split(' ')

      puts "score = #{score} matrix = #{matrix[strategy][opponent]} opponent = #{opponent}, strategy = #{strategy}"

      score += matrix[strategy][opponent]
    end

    puts "*" * 100
    puts "Final score = #{score}"
    puts "*" * 100
  end

  # X = lose
  # Y = tie
  # Z = win
  def part2
    rock = 1
    paper = 2
    scissors = 3

    win = 6
    tie = 3
    loss = 0

    matrix = {
      "A" => { "X" => scissors + loss, "Y" => rock + tie,     "Z" => paper + win },
      "B" => { "X" => rock + loss,     "Y" => paper + tie,    "Z" => scissors + win },
      "C" => { "X" => paper + loss,    "Y" => scissors + tie, "Z" => rock + win },
    }

    score = 0

    File.readlines('input.txt').each do |line|
      opponent, strategy = line.split(' ')

      puts "score = #{score} matrix = #{matrix[opponent][strategy]} opponent = #{opponent}, strategy = #{strategy}"

      score += matrix[opponent][strategy]
    end

    puts "*" * 100
    puts "Final score = #{score}"
    puts "*" * 100
  end
end

# Solution.new.part1
Solution.new.part2
