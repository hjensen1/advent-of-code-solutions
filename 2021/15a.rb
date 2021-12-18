require '../util.rb'

data = []
File.read('./15.txt').split("\n").each do |line|
  data << line.split("").map(&:to_i)
end
data[0][0] = 0

results = Array.new(data.size) { Array.new(data.first.size) }
data.each_with_index do |line, i|
  line.each_with_index do |risk, j|
    options = []
    if i > 0
      options << results[i-1][j]
    end
    if j > 0
      options << results[i][j-1]
    end
    results[i][j] = risk + (options.min || 0)
  end
end

pp results

puts results.last.last
puts "Finished in #{Time.now - @start_time} seconds."
