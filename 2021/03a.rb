require '../util.rb'

list = []
File.read('./03.txt').split("\n").each do |line|
  list << line
end
size = list.first.size
ones = [0] * size
zeros = [0] * size

list.each do |s|
  (0...size).each do |i|
    s[i] == "0" ? zeros[i] += 1 : ones[i] += 1
  end
end

a = ""
b = ""
(0...size).each do |i|
  if ones[i] > zeros[i]
    a << "1"
    b << "0"
  else
    a << "0"
    b << "1"
  end
end

puts a
puts b
puts a.to_i(2) * b.to_i(2)
puts "Finished in #{Time.now - @start_time} seconds."
