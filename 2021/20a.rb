require '../util.rb'


lines = File.read('./20.txt').split("\n")
DECODER = lines.shift
lines.shift
data = lines
STEPS = 2

data.each_with_index do |line, i|
  data[i] = "#{(['.'] * STEPS).join}#{line}#{(['.'] * STEPS).join}"
end
(STEPS).times do |i|
  data.unshift((['.'] * data.first.size).join)
  data << ((['.'] * data.first.size).join)
end

STEPS.times do |step|
  data2 = []
  data.each_with_index do |line, i|
    line2 = []
    (0...line.size).each do |j|
      chars = [[i-1, j-1], [i-1, j], [i-1, j+1], [i, j-1], [i, j], [i, j+1], [i+1, j-1], [i+1, j], [i+1, j+1]].map do |i2, j2|
        if i2 < 0 || j2 < 0 || i2 >= data.size || j2 >= line.size
          step % 2 == 0 ? "." : "#"
        else
          data[i2][j2]
        end
      end
      index = chars.join.tr(".#", "01").to_i(2)
      line2 << DECODER[index]
    end
    data2 << line2.join
  end
  data = data2
end

pp data
p data.sum { |line| line.split("").count { |x| x == "#" }}
puts "Finished in #{Time.now - @start_time} seconds."
