require '../util.rb'

lines = File.read('./21.txt').split("\n")
p1 = lines.first.split(" ").last.to_i
p2 = lines.last.split(" ").last.to_i
rolls = (1..1000).to_a

ps = [p1, p2]
ss = [0, 0]
rc = 0
loop do
  breax = false
  2.times do |i|
    r = 0
    3.times do
      r1 = rolls.shift
      r += r1
      rolls << r1
      rc += 1
    end
    ps[i] = (ps[i] - 1 + r) % 10 + 1
    ss[i] += ps[i]
    if ss[i] >= 1000
      breax = true
      break
    end
  end
  pp ps
  pp ss
  break if breax
end

puts ss.min
puts rc
puts rc * ss.min
puts "Finished in #{Time.now - @start_time} seconds."
