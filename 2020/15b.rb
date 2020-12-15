require '../util.rb'

n = nil
numbers = {}
array = [6,19,0,5,7,13,1]
(0...30_000_000).each do |i|
  if i < array.length
    n = array[i]
    numbers[n] = i unless i == array.length - 1
  else
    if numbers[n]
      n2 = i - 1 - numbers[n]
    else
      n2 = 0
    end
    numbers[n] = i - 1
    n = n2
  end
end

puts n
puts "Finished in #{Time.now - @start_time} seconds."
