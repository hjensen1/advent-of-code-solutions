@orbits = {}

File.readlines('./06.txt').each do |line|
  inner, outer = line.chomp.split(')')
  @orbits[outer] = inner
end

def chain(start)
  location = start
  result = []
  while location != 'COM'
    location = @orbits[location]
    result << location
  end
  result.reverse
end

def distance(a, b)
  chain1 = chain(a)
  chain2 = chain(b)
  i = 0
  loop do
    break if chain1[i] != chain2[i]
    i += 1
  end
  chain1.size + chain2.size - 2 * i
end

puts distance('YOU', 'SAN')
