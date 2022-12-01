require '../util.rb'

groups = []
group = []
File.read('./01a.txt').split("\n").each do |line|
  if line.empty?
    groups << group
    group = []
  else
    group << line.to_i
  end
end
groups << group

puts groups.map(&:sum).sort.last(3).sum
puts "Finished in #{Time.now - @start_time} seconds."

# Code golf

p STDIN.read.split("\n\n").map{|x|x.split.sum &:to_i}.sort.last(3).sum
