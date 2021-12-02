require '../util.rb'

x = 0
z = 0
File.read('./02.txt').split("\n").each do |line|
  c = line.split(" ")[0]
  i = line.split(" ")[1].to_i
  x += i if (c === "forward")
  z += i if (c === "down")
  z -= i if (c === "up")
end

puts x * z
puts "Finished in #{Time.now - @start_time} seconds."

p File.readlines('./02.txt').reduce([0,0]){|(x,z),l|[x+l[8].to_i,z+l[5].to_i-l[3].to_i]}.reduce(&:*)

a,b=File.readlines('./02.txt').reduce([0,0]){|(x,z),l|[x+l[8].to_i,z+l[5].to_i-l[3].to_i]};p a*b
