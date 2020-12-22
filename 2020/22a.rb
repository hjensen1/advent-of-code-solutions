require '../util.rb'

p1 = []
p2 = []
File.read('./22.txt').split("\n\n").each_with_index do |section, p|
  lines = section.split("\n")
  lines.shift
  p = p == 0 ? p1 : p2
  p.concat(lines.map(&:to_i))
end

def do_round(p1, p2)
  p1_card = p1.shift
  p2_card = p2.shift
  if p2_card > p1_card
    p2 << p2_card
    p2 << p1_card
  else
    p1 << p1_card
    p1 << p2_card
  end
end

while !p1.empty? && !p2.empty?
  do_round(p1, p2)
end

winner = p1.empty? ? p2 : p1

sum = 0
winner.reverse.each_with_index { |x, i| sum += x * (i + 1) }
puts sum

puts "Finished in #{Time.now - @start_time} seconds."
