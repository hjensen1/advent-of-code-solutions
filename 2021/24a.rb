require '../util.rb'

subroutines = []
File.read('./24.txt').split("\n").each do |line|
  next if line.empty?
  i = line.split(" ")
  if i.last < "a"
    i[i.size - 1] = i.last.to_i
  end
  if i.first == "inp"
    subroutines << [i]
  else
    subroutines.last << i
  end
end

model = 99_999_999_999_999
REGISTERS = {
  "w" => 0,
  "x" => 0,
  "y" => 0,
  "z" => 0,
}

def do_subroutine(w, z, instructions)
  REGISTERS["w"] = w
  REGISTERS["z"] = z
  instructions.each do |(name, a, b)|
    if name == "inp"
      REGISTERS[a] = w
    else
      b = b.is_a?(String) ? REGISTERS[b] : b
      if name == "add"
        REGISTERS[a] += b
      elsif name == "mul"
        REGISTERS[a] *= b
      elsif name == "div"
        raise "Divide by zero" if b == 0
        REGISTERS[a] /= b
      elsif name == "mod"
        raise "Divide by zero" if b == 0
        REGISTERS[a] %= b
      elsif name == "eql"
        REGISTERS[a] = REGISTERS[a] == b ? 1 : 0
      end
    end
  end
  return REGISTERS["z"]
end

binding.irb
exit

SOLUTIONS = Array.new(14) { [] }

# sizes = [6, 2, 3, 4, 6, 5, 6, 6, 5, 4, 5, 4, 3, 2]

(0..13).to_a.reverse.each do |i|
  outputs = i == 13 ? Set.new([0]) : Set.new(SOLUTIONS[i + 1].map { |x| x[:z] })
  puts outputs.size
  # puts sizes[i]
  pp outputs if outputs.size < 100
  (1..9).to_a.reverse.each do |w|
    (-10000..10000).each do |z|
      result = do_subroutine(w, z, subroutines[i])
      if outputs.include?(result)
        SOLUTIONS[i] << { w: w, z: z, output: result }
      end
    end
  end
end

# loop do
#   inputs = model.to_s.split("").map(&:to_i)
#   if inputs.all? { |x| x != 0 }
#     z = 0
#     subroutines.each_with_index do |subroutine, i|
#       w = inputs.shift
#       print "#{model}[#{i}](#{w}, #{z}) = "
#       z = do_subroutine(w, z, subroutine)
#       puts z
#     end
#     pp REGISTERS
#     break if REGISTERS["z"] == 0
#   end
#   REGISTERS["w"] = 0
#   REGISTERS["x"] = 0
#   REGISTERS["y"] = 0
#   REGISTERS["z"] = 0
#   model -= 1
# end

# puts model
puts "Finished in #{Time.now - @start_time} seconds."

# z % 26 == w + 13
# z < 26




# x = z % 26 == w + 13 ? 0 : 1
# z = z / 26 * (25 * x + 1) + w + 6 * x

# z = z / 26 + w
# z = z / 26 * (26) + w + 6

def f0(w, z)
  w + 5
end

def f1(w, z)
  z * (26) + (w + 5)
end

def f2(w, z)
  z * (26) + (w + 1)
end

def f3(w, z)
  z * 26 + w + 15
end

def f4(w, z)
  z * 26 + w + 2
end

def f5(w, z)
  if z % 26 == w + 1
    z / 26
  else
    z / 26 * 26 + w + 2
  end
end

def f6(w, z)
  z * 26 + w + 5
end

def f7(w, z)
  if z % 26 == w + 8
    z / 26
  else
    z / 26 * 26 + w + 8
  end
end

def f8(w, z)
  if z % 26 == w + 7
    z / 26
  else
    z / 26 * 26 + w + 14
  end
end

def f9(w, z)
  if z % 26 == w + 8
    z / 26
  else
    z / 26 * 26 + w + 12
  end
end

def f10(w, z)
  z * 26 + w + 7
end

def f11(w, z)
  if z % 26 == w + 2
    z / 26
  else
    z / 26 * 26 + w + 14
  end
end

# 
def f12(w, z)
  if z % 26 == w + 2
    z / 26
  else
    z / 26 * 26 + w + 13
  end
end

# z = w + 13
def f13(w, z)
  if z % 26 == w + 13
    z / 26
  else
    z / 26 * 26 + w + 6
  end
end
