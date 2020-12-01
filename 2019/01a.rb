sum = 0
File.readlines('./01.txt').each do |line|
  sum += line.to_i / 3 - 2
end
puts sum
