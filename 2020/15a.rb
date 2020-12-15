require '../util.rb'

n = nil
numbers = Hash.new { |h, k| h[k] = [] }
array = [6,19,0,5,7,13,1]
(0...2020).each do |i|
  if i < array.length
    n = array[i]
    numbers[n] << i
  else
    if numbers.key?(n) && numbers[n].size > 1
      n = numbers[n].last - numbers[n][numbers[n].length - 2]
      numbers[n] << i
    else
      n = 0
      numbers[n] << i
    end
  end
  puts n
end

puts n
puts "Finished in #{Time.now - @start_time} seconds."
