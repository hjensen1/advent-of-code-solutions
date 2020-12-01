def fuel(mass)
  return 0 if mass < 9
  f = mass / 3 - 2
  f + fuel(f)
end

sum = 0
File.readlines('./01.txt').each do |line|
  sum += fuel(line.to_i)
end
puts sum
