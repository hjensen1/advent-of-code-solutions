require '../util.rb'

fishes = File.read('./06.txt').split(",").map(&:to_i)

counts = {}
(0..8).each { |i| counts[i] = fishes.count { |x| x == i } }

256.times do
  newCounts = {}
  (1..8).each do |i|
    newCounts[i-1] = counts[i]
  end
  newCounts[8] = counts[0]
  newCounts[6] += counts[0]
  counts = newCounts
end

puts counts.values.sum
puts "Finished in #{Time.now - @start_time} seconds."

# 256.times.reduce(File.read('./06.txt').split(",").map(&:to_i).tally) do |c|
#   [c[1],c[2],c[3],c[4],c[5],c[6],c[7]+c[0],c[8],c[0]]
# end
