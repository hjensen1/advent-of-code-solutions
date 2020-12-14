require '../util.rb'

memory = {}
mask = ''
File.read('./14.txt').split("\n").each do |line|
  if line.start_with?('mask')
    mask = line.split(' ').last
  else
    address = line[4, 10].to_i
    value = line.split(" ").last.to_i
    value = value & (mask.gsub('X', '1').to_i(2)) | (mask.gsub('X', '0').to_i(2))
    p [address, value]
    memory[address] = value
  end
end

puts memory.values.sum
puts "Finished in #{Time.now - @start_time} seconds."
