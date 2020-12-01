require '../util.rb'

def process_line(list)
  result = {}
  x = 0
  y = 0
  list.each do |instruction|
    x, y = process_instruction(instruction, result, x, y)
  end
  result
end

def process_instruction(instruction, result, x, y)
  direction = instruction[0]
  count = instruction[1, 10].to_i
  count.times do
    if direction == 'R'
      x += 1
    elsif direction == 'L'
      x -= 1
    elsif direction == 'U'
      y += 1
    elsif direction == 'D'
      y -= 1
    end
    result[to_point(x, y)] = true
  end
  return [x, y]
end

lines = File.read('./03.txt').split("\n")
line1, line2 = lines.map { |line| line.split(',') }
spaces1 = process_line(line1)
spaces2 = process_line(line2)
min = 100000000
spaces1.keys.each do |point|
  if spaces2.key?(point)
    distance = from_point(point).sum
    min = distance if distance < min
  end
end
puts min
