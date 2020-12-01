@orbits = Hash.new { |h, k| h[k] = [] }

File.readlines('./06.txt').each do |line|
  inner, outer = line.chomp.split(')')
  @orbits[inner] << outer
end

def compute_orbits(x, depth = 1)
  list = @orbits[x]
  return (list.size * depth) + list.sum { |orbit| compute_orbits(orbit, depth + 1) }
end

puts compute_orbits('COM')
