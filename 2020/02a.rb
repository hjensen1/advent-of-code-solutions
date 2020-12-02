load '../util.rb'

def valid?(line)
  parts = line.split
  min, max = parts[0].split('-').map(&:to_i)
  char = parts[1][0]
  string = parts[2]
  num = string.split('').count { |x| x == char}
  num >= min && num <= max
end

count = 0
File.readlines('./02.txt').each do |line|
  count += 1 if valid?(line)
end

puts count
puts "Finished in #{Time.now - @start_time} seconds."
