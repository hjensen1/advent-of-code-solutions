require '../util.rb'

result = {}
coords = Array.new(10) { [0, 0] }
File.read('./09.txt').split("\n").each do |line|
  count = line.split.last.to_i
  count.times do
    if line[0] == "R"
      coords[0][0] += 1
    elsif line[0] == "L"
      coords[0][0] -= 1
    elsif line[0] == "U"
      coords[0][1] += 1
    elsif line[0] == "D"
      coords[0][1] -= 1
    end
    coords.each_cons(2) do |h, t|
      dx = h[0] - t[0]
      dy = h[1] - t[1]
      if dx.abs == 2
        t[0] = (t[0] + h[0]) / 2
        t[1] = h[1] if dy.abs == 1
        t[1] = (t[1] + h[1]) / 2 if dy.abs == 2
      end
      dx = h[0] - t[0]
      dy = h[1] - t[1]
      if dy.abs == 2
        t[1] = (t[1] + h[1]) / 2
        t[0] = h[0] if dx.abs == 1
        t[0] = (t[0] + h[0]) / 2 if dx.abs == 2
      end
    end
    result[[coords.last[0], coords.last[1]]] = true
  end
end

pp coords
puts result.size
puts "Finished in #{Time.now - @start_time} seconds."
