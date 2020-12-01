a, b = File.read('./04.txt').split('-').map(&:to_i)

puts ((a..b).to_a.select do |x|
  x = x.to_s
  increasing = true
  double = false
  prev = ''
  (0..5).each do |i|
    char = x[i]
    increasing = false if char < prev
    double = true if char == prev
    prev = char
  end
  increasing && double
end.size)
