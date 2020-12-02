load '../util.rb'

def valid?(line)
  parts = line.split
  min, max = parts[0].split('-').map(&:to_i)
  char = parts[1][0]
  string = parts[2]
  (string[min - 1] == char) ^ (string[max - 1] == char)
end

count = 0
File.readlines('./02.txt').each do |line|
  count += 1 if valid?(line)
end

puts count
puts "Finished in #{Time.now - @start_time} seconds."
