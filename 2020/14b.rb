require '../util.rb'

memory = {}
mask = ''
x_indices = []
File.read('./14.txt').split("\n").each do |line|
  if line.start_with?('mask')
    mask = line.split(' ').last
    x_indices = []
    (0...mask.length).each do |i|
      x_indices << i if mask[i] == 'X'
    end
  else
    address = line[4, 10].to_i
    value = line.split(" ").last.to_i
    address = address | (mask.gsub('X', '0').to_i(2))
    (0...(2 ** x_indices.length)).each do |n|
      bits = []
      while n > 0
        bits << n % 2
        n /= 2
      end
      floating = address.to_s(2).rjust(36, '0')
      x_indices.each_with_index do |x_index, i|
        floating[x_index] = (bits[i] || '0').to_s
      end
      memory[floating.to_i(2)] = value
    end
  end
end

puts memory.values.sum
puts "Finished in #{Time.now - @start_time} seconds."
