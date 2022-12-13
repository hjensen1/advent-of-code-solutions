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
  if packets.size == 2
    pp packets
    result << ((packets[0] <=> packets[1]) <= 0)
    packets = []
  end
end

sum = 0
result.each_with_index { |x, i| sum += x ? i + 1 : 0 }
puts sum
puts "Finished in #{Time.now - @start_time} seconds."
