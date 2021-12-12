require '../util.rb'

data = []
File.read('./11.txt').split("\n").each do |line|
  data << line.split("").map(&:to_i)
end
# pp data

counter = 0
(0...1000).each do |step|
  data.each { |line| line.each_with_index { |x, i| line[i] = x + 1 } }
  loop do
    changed = false
    data.each_with_index do |line, i|
      line.each_with_index do |x, j|
        if x > 9 && x < 1000
          line[j] = 1000
          [i, i+1, i-1].product([j, j+1, j-1]).each do |(i2, j2)|
            data[i2][j2] += 1 if i2 >= 0 && j2 >= 0 && data[i2] && data[i2][j2]
          end
          counter += 1
          changed = true
        end
      end
    end
    break unless changed
  end
  data.each { |line| line.each_with_index { |x, i| line[i] = 0 if x > 9 } }
  if data.all? { |line| line.all? { |x| x == 0 }}
    puts step + 1
    break
  end
  # p step
  # pp data
end

puts "Finished in #{Time.now - @start_time} seconds."
