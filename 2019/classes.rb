class IntcodeProcess
  OPS = {
    1 => { name: :add, signature: [0,1,1,2] },
    2 => { name: :multiply, signature: [0,1,1,2] },
    3 => { name: :input, signature: [0,2] },
    4 => { name: :output, signature: [0,1] },
    5 => { name: :jump_if_true, signature: [0,1,1] },
    6 => { name: :jump_if_false, signature: [0,1,1] },
    7 => { name: :less_than, signature: [0,1,1,2] },
    8 => { name: :equals, signature: [0,1,1,2] },
    9 => { name: :adjust_relative_base, signature: [0,1] },
    99 => { name: :do_exit, signature: [0] }
  }

  attr_accessor :memory, :index, :inputs, :outputs, :exited, :steps

  def initialize(program, inputs: [])
    @index = 0
    @memory = Hash.new { |h, k| h[k] = 0 }
    program.split(',').map(&:to_i).each_with_index do |x, i|
      memory[i] = x
    end
    @inputs = inputs
    @exited = false
    @relative_base = 0
    @steps = 0
    # @diagnostic = true
  end

  def add(a, b, c)
    memory[c] = a + b
    diagnostic(4, c) if @diagnostic
    true
  end

  def multiply(a, b, c)
    memory[c] = a * b
    diagnostic(4, c) if @diagnostic
    true
  end

  def input(a)
    return false if @inputs.empty?
    memory[a] = @inputs.shift
    diagnostic(2, a) if @diagnostic
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

  def less_than(a, b, c)
    memory[c] = a < b ? 1 : 0
    diagnostic(4, c) if @diagnostic
    true
  end

  def equals(a, b, c)
    memory[c] = a == b ? 1 : 0
    diagnostic(4, c) if @diagnostic
    true
  end

  def adjust_relative_base(a)
    @relative_base += a
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
    instruction = memory[index]
    op = OPS[instruction % 100]
    return 'error' unless op
    arguments = (1...(op[:signature].size)).map do |i|
      type = op[:signature][i]
      mode = instruction / (10 ** (i + 1)) % 10
      if type == 1
        if mode == 0 # position mode
          memory[memory[index + i]]
        elsif mode == 1 # immediate mode
          memory[index + i]
        elsif mode == 2 # relative mode
          memory[@relative_base + memory[index + i]]
        else
          raise 'Bad mode'
        end
      elsif type == 2
        if mode == 2
          memory[index + i] + @relative_base
        else
          memory[index + i]
        end
      else
        raise 'Bad type'
      end
    end
    result = send(op[:name], *arguments)
    @index += op[:signature].size if result
    @steps += 1
    result
  end

  def diagnostic(arg_count, changed_index)
    memory.size.times do |i|
      x = memory[i]
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
