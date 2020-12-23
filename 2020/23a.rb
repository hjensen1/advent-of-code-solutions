require '../util.rb'

cups = '315679824'.split('').map(&:to_i)
100.times do
  cup = cups.shift
  group = cups[0, 3]
  cups = cups[3, cups.length]
  placement = cup - 1
  while !cups.include?(placement)
    placement -= 1
    placement = cups.max if placement < cups.min
  end
  index = cups.index(placement)
  puts index
  cups = cups[0, index + 1] + group + cups[index + 1, cups.length] + [cup]
  puts cups.join
end

while cups[0] != 1
  cups << cups.shift
end

puts cups[1, cups.length].join
puts "Finished in #{Time.now - @start_time} seconds."
