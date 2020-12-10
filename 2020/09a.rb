require '../util.rb'

def check(list, n, size)
  if list.size < size
    list << n
    true
  else
    match = false
    (0...list.size).each do |i|
      break if match
      x = list[i]
      ((i+1)...list.size).each do |j|
        y = list[j]
        if x + y == n
          match = true
          break
        end
      end
    end
    return false unless match
    list.shift
    list << n
  end
end

list = []
File.read('./09.txt').split("\n").each do |line|
  result = check(list, line.to_i, 25)
  unless result
    puts line
    break
  end
end

puts "Finished in #{Time.now - @start_time} seconds."
