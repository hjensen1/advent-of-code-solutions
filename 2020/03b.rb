require '../util.rb'

def stuff2(x, y)
  @result = 0
  @position = 0
  File.read('./03.txt').split("\n").each_with_index do |line, index|
    if index % y == 0
      @result += line[@position] == '#' ? 1 : 0
      @position = (@position + x) % (line.length)
    end
  end
  puts @result
  @result
end

puts stuff2(1, 1) * stuff2(3, 1) * stuff2(5, 1) * stuff2(7, 1) * stuff2(1, 2)
puts "Finished in #{Time.now - @start_time} seconds."
