require '../util.rb'

list = []
File.read('./03.txt').split("\n").each do |line|
  list << line
end
size = list.first.size

def mode(list, i)
  list.map { |x| x[i] }.count { |x| x == "1" } >= list.size / 2.0 ? "1" : "0"
end

as = list
(0...size).each do |i|
  break if as.size <= 1
  c = mode(as, i)
  as = as.select { |x| x[i] == c }
end

bs = list
(0...size).each do |i|
  break if bs.size <= 1
  c = mode(bs, i)
  bs = bs.select { |x| x[i] != c }
end

puts as[0]
puts bs[0]
puts as[0].to_i(2) * bs[0].to_i(2)
puts "Finished in #{Time.now - @start_time} seconds."

# Code Golf

a, b = [!1, !!1].map { |b|
  (-11..0).reduce(File.readlines('./03.txt').map { |x| x.to_i(2) }) { |l, p|
    m = 2 ** -p
    d = l.map { |x| x & m }.sort[l.size / 2]
    l.select { |x| (x & m == d) ^ b || l.size == 1 }
  }
}
p a[0] * b[0]
