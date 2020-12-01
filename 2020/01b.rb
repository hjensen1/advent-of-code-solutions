load '../util.rb'

list = []
File.readlines('./01.txt').each do |line|
  list << line.to_i
end

def thing(list)
  list.each_with_index do |x, i|
    list.each_with_index do |y, j|
      list.each_with_index do |z, k|
        if x + y + z == 2020
          return x * y * z
        end
      end
    end
  end
end

puts thing(list)
puts "Finished in #{Time.now - @start_time} seconds."
