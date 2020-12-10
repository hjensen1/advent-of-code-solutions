require '../util.rb'

list = []
sum = 0
File.read('./09.txt').split("\n").each do |line|
  list << line.to_i
  sum += line.to_i
  while sum > 22477624
    sum -= list.shift
  end
  break if sum == 22477624 && list.size > 1
end

p list
puts list.min + list.max
puts "Finished in #{Time.now - @start_time} seconds."
