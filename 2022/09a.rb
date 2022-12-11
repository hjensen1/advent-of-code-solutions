require '../util.rb'

result = { [0,0] => true }
hx = hy = tx = ty = 0
File.read('./09.txt').split("\n").each do |line|
  count = line.split.last.to_i
  count.times do
    if line[0] == "R"
      hx += 1
    elsif line[0] == "L"
      hx -= 1
    elsif line[0] == "U"
      hy += 1
    elsif line[0] == "D"
      hy -= 1
    end
    dx = hx - tx
    dy = hy - ty
    if dx.abs == 2
      tx = (tx + hx) / 2
      ty = hy
    end
    if dy.abs == 2
      ty = (ty + hy) / 2
      tx = hx
    end
    result[[tx, ty]] = true
  end
end

pp result.keys
puts result.size
puts "Finished in #{Time.now - @start_time} seconds."
