require '../util.rb'

start = 0
list = []
File.read('./13.txt').split("\n").each do |line|
  if start > 0
    list = line.split(',').map(&:to_i)
  else
    start = line.to_i
  end
end

time = 1
product = 1
list.each_with_index do |x, i|
  next if x == 0
  test = time
  loop do
    if (test + i) % x == 0
      product *= x
      time = test
      break
    end
    test += product
  end
end

puts time
puts "Finished in #{Time.now - @start_time} seconds."
