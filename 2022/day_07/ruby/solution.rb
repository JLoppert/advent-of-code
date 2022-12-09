class Solution
  attr_reader :root, :current_node, :current_line

  def initialize
    @root = Node.new(name: "/", parent: nil)
    @current_node = @root
    @current_line = nil
  end

  def part1
    process_input

    sizes = @root.directories_matching(size: 100_000, operator: :<=)

    print_size(sizes.sum)
  end

  def part2
    process_input

    total_size = 70_000_000
    needed_size = 30_000_000

    free_space = total_size - @root.size
    deletion_size = needed_size - free_space

    sizes = @root.directories_matching(size: deletion_size, operator: :>=)

    print_size(sizes.min)
  end

  private

  def print_size(size)
    puts "*" * 100
    puts "size: #{size}"
    puts "*" * 100
  end

  def input_file_name
    @input_file_name ||= 'input.txt'
  end

  def input
    @input ||= File.read(File.join(File.dirname(__FILE__), '..', input_file_name))
  end

  def process_input
    input.each_line do |line|
      @current_line = Command.new(line)

      process_line
    end
  end

  def process_line
    if @current_line.command?
      if @current_line.cd?
        cd(@current_line.name)
      end
    elsif @current_line.directory?
      @current_node.add_directory(name: @current_line.name)
    else
      @current_node.add_file(name: @current_line.name, new_size: @current_line.size)
    end
  end

  def cd(dir)
    if dir == '/'
      @current_node = @root
    elsif dir == '..'
      @current_node = @current_node.parent
    else
      @current_node = @current_node.directories[dir]
    end
  end

  class Command
    def initialize(input)
      @input = input
    end

    def command?
      @input.start_with?("$")
    end

    def directory?
      @input.start_with?("dir")
    end

    def cd?
      @input.start_with?("$ cd")
    end

    def name
      @input.split(" ").last
    end

    def size
      @input.split(" ").first.to_i
    end
  end

  class Node
    attr_accessor :name, :parent, :directories, :files, :size

    def initialize(name:, parent:)
      @name = name || '/'
      @parent = parent || nil
      @directories = {}
      @files = {}
      @size = 0
    end

    def print(level: 0)
      puts "#{" " * level} name=#{name} parent=#{parent&.name} size=#{size} files=#{files.inspect} directories=#{directories.keys}"

      directories.each do |name, child_node|
        child_node.print(level: level + 2)
      end
    end

    def directories_matching(size:, operator:)
      sizes = []

      if self.size.public_send(operator, size)
        sizes << self.size
      end

      directories.each do |name, child_node|
        sizes += child_node.directories_matching(size: size, operator: operator)
      end

      sizes
    end

    def add_directory(name:)
      if directories[name].nil?
        directories[name] = Node.new(name: name, parent: self)
      end
    end

    def add_file(name:, new_size:)
      if files[name].nil?
        files[name] = new_size

        add_size(new_size: new_size)
      end
    end

    def add_size(new_size:)
      self.size += new_size

      if parent
        parent.add_size(new_size: new_size)
      end
    end
  end
end

Solution.new.part1
Solution.new.part2
