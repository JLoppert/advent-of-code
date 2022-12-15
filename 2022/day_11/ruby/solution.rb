class Solution
  def initialize(rounds:, default_worry_level: true)
    @rounds = rounds
    @default_worry_level = default_worry_level
    @monkeys = initialize_monkeys
  end

  def run
    @rounds.times do |round|
      @monkeys.each(&:process_turn)
    end

    monkey_business = @monkeys.map(&:inspection_count).max(2).reduce(&:*)

    puts "*" * 100
    puts "monkey business: #{monkey_business}"
    puts "*" * 100
  end

  private

  def input_file_name
    @input_file_name ||= 'input.txt'
  end

  def input
    @input ||= File.open(File.join(File.dirname(__FILE__), '..', input_file_name))
  end

  def initialize_monkeys
    monkeys = []

    input.each_slice(7).with_index do |monkey_input, index|
      monkey_input = monkey_input.map(&:strip)
      monkeys << create_monkey(monkey_input, index)
    end

    # replace each monkey's true/false monkey ID
    # with a reference to the actual monkey object
    monkeys.each_with_index do |monkey, index|
      monkey.set_monkey(condition: true, monkey: monkeys[monkey.true_monkey_id])
      monkey.set_monkey(condition: false, monkey: monkeys[monkey.false_monkey_id])
    end

    unless @default_worry_level
      # multiply all the test divisible values together to get the worry_level
      worry_level = monkeys.map(&:denominator).inject(&:*)
      monkeys.each { |monkey| monkey.set_worry_level(worry_level) }
    end

    monkeys
  end

  def create_monkey(monkey_input, index)
    items = monkey_input[1].delete_prefix("Starting items: ").split(', ')
    operator, operand = monkey_input[2].delete_prefix("Operation: new = old ").split(' ')
    denominator = monkey_input[3].delete_prefix("Test: divisible by ")
    true_monkey_id = monkey_input[4].delete_prefix("If true: throw to monkey ")
    false_monkey_id = monkey_input[5].delete_prefix("If false: throw to monkey ")

    Monkey.new(
      id: index,
      items: items,
      operator: operator,
      operand: operand,
      denominator: denominator,
      true_monkey_id: true_monkey_id,
      false_monkey_id: false_monkey_id
    )
  end

  class Monkey
    attr_reader :denominator, :true_monkey_id, :false_monkey_id, :inspection_count

    def initialize(id:, items:, operator:, operand:, denominator:, true_monkey_id:, false_monkey_id:)
      @id = id
      @items = items.map(&:to_i)
      @operator = operator.to_sym
      @operand = operand
      @denominator = denominator.to_i
      @true_monkey_id = true_monkey_id.to_i
      @false_monkey_id = false_monkey_id.to_i
      @on_true_monkey = nil
      @on_false_monkey = nil
      @inspection_count = 0
    end

    def set_monkey(condition:, monkey:)
      if condition
        @on_true_monkey = monkey
      else
        @on_false_monkey = monkey
      end
    end

    def set_worry_level(worry_level)
      @worry_level = worry_level
    end

    def operand
      @operand == 'old' ? @current_item : @operand.to_i
    end

    def process_turn
      @items.count.times do
        @current_item = @items.shift

        inspect_item
        modify_item
        throw_item
      end
    end

    def inspect_item
      @inspection_count += 1

      @current_item = @current_item.public_send(@operator, operand)
    end

    def modify_item
      if @worry_level
        @current_item %= @worry_level
      else
        @current_item /= 3
      end
    end

    def throw_item
      target_monkey = divisible? ? @on_true_monkey : @on_false_monkey

      target_monkey.add_item(@current_item)
    end

    def divisible?
      (@current_item % @denominator == 0)
    end

    def add_item(item)
      @items << item
    end

    def print_items
      puts "Monkey #{@id}: #{@items.join(', ')}"
    end

    def print_inspections
      puts "Monkey #{@id}: inspected items #{@inspection_count} times"
    end
  end
end

Solution.new(rounds: 20, default_worry_level: true).run # 119715
Solution.new(rounds: 10_000, default_worry_level: false).run # 18085004878
