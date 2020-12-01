load '../util.rb'

list = {}
File.readlines('./01.txt').each do |line|
  list[line.to_i] = true
end

def thing(list)
  list.keys.each do |i|
    if list.key?(2020 - i)
      return i * (2020 - i)
    end
  end
end

puts thing(list)
puts "Finished in #{Time.now - @start_time} seconds."
