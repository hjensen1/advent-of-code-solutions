require '../util.rb'

class Integer
  alias old_compare <=>

  def <=>(other)
    if other.is_a?(Array)
      [self] <=> other
    else
      old_compare(other)
    end
  end
end

class Array
  alias old_compare <=>

  def <=>(other)
    if other.is_a?(Integer)
      old_compare([other])
    else
      old_compare(other)
    end
  end
end

result = []
packets = []
File.read('./13.txt').split("\n").each do |line|
  next if line.empty?
  packets << eval(line)
end
packets << [[2]]
packets << [[6]]

packets.sort!
a = packets.find_index([[2]]) + 1
b = packets.find_index([[6]]) + 1
puts a * b
puts "Finished in #{Time.now - @start_time} seconds."
