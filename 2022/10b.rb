require '../util.rb'

cycle = 0
value = 1
result = []
File.read('./10.txt').split("\n").each do |line|
  result << ((cycle % 40 - value).abs <= 1 ? "#" : ' ')
  if line == 'noop'
    cycle += 1
  else
    cycle += 1
  end
  if line != 'noop'
    result << ((cycle % 40 - value).abs <= 1 ? "#" : ' ')
    cycle += 1
    value += line.split.last.to_i
  end
end
result = result.each_slice(result.size / 6).to_a
result.each { |line| puts line.join('') }
puts "Finished in #{Time.now - @start_time} seconds."
