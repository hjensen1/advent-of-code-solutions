require '../util.rb'

list = []
list = File.read('./07.txt').split(",").map(&:to_i)

min = 1_000_000_000_000
(list.min..list.max).each do |t|
  sum = list.map { |x| (x - t).abs }.sum
  min = sum if sum < min
end

puts min
puts "Finished in #{Time.now - @start_time} seconds."
