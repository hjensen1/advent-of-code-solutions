class IntcodeProcess
  OPS = {
    1 => { name: :add, size: 4 },
    2 => { name: :multiply, size: 4 },
    3 => { name: :input, size: 2 },
    4 => { name: :output, size: 2 },
    5 => { name: :jump_if_true, size: 3 },
    6 => { name: :jump_if_false, size: 3 },
    7 => { name: :less_than, size: 4 },
    8 => { name: :equals, size: 4 },
    99 => { name: :do_exit, size: 1 }
  }

  attr_accessor :list, :index, :inputs, :outputs, :exited

  def initialize(list, inputs: [])
    @index = 0
    @list = list.split(',').map(&:to_i)
    @inputs = inputs
    @exited = false
    # @diagnostic = true
  end

  def add(a, b, _c)
    list[list[@index + 3]] = a + b
    diagnostic(4, list[@index + 3]) if @diagnostic
    true
  end

  def multiply(a, b, _c)
    list[list[@index + 3]] = a * b
    diagnostic(4, list[@index + 3]) if @diagnostic
    true
  end

  def input(_)
    return false if @inputs.empty?
    list[list[@index + 1]] = @inputs.shift
    diagnostic(2, list[@index + 1]) if @diagnostic
    true
  end

  def output(a)
    # puts "#{@index} Output: #{a}"
    @outputs << a
    true
  end

  def jump_if_true(a, b)
    @index = b - 3 if a != 0
    true
  end

  def jump_if_false(a, b)
    @index = b - 3 if a == 0
    true
  end

  def less_than(a, b, _c)
    list[list[@index + 3]] = a < b ? 1 : 0
    diagnostic(4, list[@index + 3]) if @diagnostic
    true
  end

  def equals(a, b, _c)
    list[list[@index + 3]] = a == b ? 1 : 0
    diagnostic(4, list[@index + 3]) if @diagnostic
    true
  end

  def do_exit
    return 'exit'
  end

  def start(inputs: [])
    @inputs.concat(inputs)
    @outputs = []
    unless @exited
      loop do
        result = process_instruction
        if !result
          break
        elsif result == 'exit'
          @exited = true
          break
        elsif result == 'error'
          puts "Error at position #{@index}."
          return 'error'
        end
      end
    end
    @outputs
  end

  def process_instruction
    instruction = list[index]
    op = OPS[instruction % 100]
    return 'error' unless op
    arguments = (1...(op[:size])).map do |i|
      mode = instruction / (10 ** (i + 1)) % 10
      mode == 1 ? list[index + i] : list[list[index + i]]
    end
    result = send(op[:name], *arguments)
    @index += op[:size] if result
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

  def inspect
    "#<IntcodeProcess index=#{@index} inputs=[#{@inputs.join(',')}] exited=#{@exited}"
  end
end

class Processor
  def initialize(programs, input_id, output_id)
    @programs = programs
    @input = @programs[input_id]
    @output = @programs[output_id]
  end

  def start(inputs: [])
    outputs = []
    program = @input
    loop do
      outputs = program[:process].start(inputs: inputs)
      # puts "#{program[:id]}: #{outputs.join(',')}"
      break if outputs == 'error'
      program = @programs[program[:output_id]]
      break if !program || program[:process].exited
      inputs = outputs
    end
    outputs
  end
end
