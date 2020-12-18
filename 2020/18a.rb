require '../util.rb'

def separate_expressions(string)
  depth = 0
  expressions = []
  expression = ''
  string.each_char do |char|
    if char == '('
      depth += 1
      next if depth == 1
    elsif char == ')'
      depth -= 1
      next if depth == 0
    end
    if depth > 0
      expression << char
    elsif char == '+' || char == '*'
      expressions << expression
      expressions << char
      expression = ''
    else
      expression << char
    end
  end
  expressions << expression unless expression.empty?
  # p expressions
  expressions
end

def evaluate(expression)
  parts = expression.is_a?(Array) ? expression : separate_expressions(expression)
  if /^\d+$/.match(parts[0])
    first = parts[0].to_i
  else
    first = evaluate(parts[0])
  end
  return first if parts.size < 3

  if /^\d+$/.match(parts[2])
    second = parts[2].to_i
  else
    second = evaluate(parts[2])
  end

  result = parts[1] == '+' ? first + second : first * second
  evaluate([result.to_s] + parts[3, parts.size - 1])
end

result = 0
File.read('./18.txt').split("\n").each do |line|
  line = line.gsub(' ', '')
  puts line
  puts evaluate(line)
  result += evaluate(line)
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."

# Cheater solution

class Integer
  def -(other)
    self * other
  end
  def /(other)
    self + other
  end
end
p File.open('./18.txt').readlines.map { |expr| eval(expr.tr('*', '-')) }.sum
