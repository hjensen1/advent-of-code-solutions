class IntCode
  OPS = {
    1 => {
      name: :add,
      size: 4,
    },
    2 => {
      name: :multiply,
      size: 4,
    },
    3 => {
      name: :input,
      size: 2,
    },
    4 => {
      name: :output,
      size: 2,
    },
    5 => {
      name: :jump_if_true,
      size: 3,
    },
    6 => {
      name: :jump_if_false,
      size: 3,
    },
    7 => {
      name: :less_than,
      size: 4,
    },
    8 => {
      name: :equals,
      size: 4,
    },
    99 => {
      name: :do_exit,
      size: 1,
    }
  }

  attr_accessor :list, :index

  def initialize(list, input)
    @list = list.split(',').map(&:to_i)
    @index = 0
    @input = input
    @diagnostic = true
  end

  def add(a, b, _c)
    list[list[@index + 3]] = a + b
    diagnostic(4, list[@index + 3]) if @diagnostic
  end

  def multiply(a, b, _c)
    list[list[@index + 3]] = a * b
    diagnostic(4, list[@index + 3]) if @diagnostic
  end

  def input(_)
    list[list[@index + 1]] = @input
    diagnostic(2, list[@index + 1]) if @diagnostic
  end

  def output(a)
    puts a
  end

  def jump_if_true(a, b)
    @index = b - 3 if a != 0
  end

  def jump_if_false(a, b)
    @index = b - 3 if a == 0
  end

  def less_than(a, b, _c)
    list[list[@index + 3]] = a < b ? 1 : 0
    diagnostic(4, list[@index + 3]) if @diagnostic
  end

  def equals(a, b, _c)
    list[list[@index + 3]] = a == b ? 1 : 0
    diagnostic(4, list[@index + 3]) if @diagnostic
  end

  def do_exit
    return 'exit'
  end

  def execute
    loop do
      break if process_instruction == 'exit'
    end
  end

  def process_instruction
    instruction = list[index]
    op = instruction % 100
    arguments = (1...(OPS[op][:size])).map do |i|
      mode = instruction / (10 ** (i + 1)) % 10
      mode == 1 ? list[index + i] : list[list[index + i]]
    end
    result = send(OPS[op][:name], *arguments)
    @index += OPS[op][:size]
    result
  end

  def diagnostic(arg_count, changed_index)
    list.each_with_index do |x, i|
      print "\e[0m" if i == index + arg_count
      print "\e[0m" if i == changed_index + 1
      print "\e[1m\e[34m" if i == index
      print "\e[1m\e[31m" if i == changed_index
      print x
      print ","
    end
    puts "\e[0m"
    puts
  end
end

File.readlines('./05.txt').each do |line|
  IntCode.new(line, 5).execute
end
