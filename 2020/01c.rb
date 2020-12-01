load '../util.rb'

list = []
hash = {}
File.readlines('./01.txt').each do |line|
  list << line.to_i
end
list.each do |x|
  list.each do |y|
    hash[x + y] = [x, y]
  end
end

def thing(list, hash)
  list.each_with_index do |x, i|
    if a = hash[2020 - x]
      return a[0] * a[1] * x
    end
  end
end

puts thing(list, hash)
puts "Finished in #{Time.now - @start_time} seconds."
