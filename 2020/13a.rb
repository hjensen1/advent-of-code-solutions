require '../util.rb'

start = 0
list = []
File.read('./13.txt').split("\n").each do |line|
  if start > 0
    list = line.split(',').map(&:to_i).select { |x| x > 0 }
  else
    start = line.to_i
  end
end

best = 0
min = 100000000
d = 0
list.each do |x|
  r = (start / x) * x
  r += x if r < start
  if r < min
    min = r
    best = x
    d = r - start
  end
end

puts best * d
puts "Finished in #{Time.now - @start_time} seconds."
