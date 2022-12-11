require '../util.rb'

cycle = 1
value = 1
result = 0
File.read('./10.txt').split("\n").each do |line|
  if line == 'noop'
    cycle += 1
  else
    cycle += 1
  end
  if cycle % 40 == 20
    result += cycle * value
  end
  if line != 'noop'
    cycle += 1
    value += line.split.last.to_i
    if cycle % 40 == 20
      result += cycle * value
    end
  end
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."
