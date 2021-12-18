require '../util.rb'

DEBUG = 0
MAP = { "[" => -1, "]" => -2, "," => -3 }
MAP_INVERT = MAP.invert
DEPTH = { MAP["["] => 1, MAP["]"] => -1 }

data = []
File.read('./18.txt').split("\n").each do |line|
  data << line.each_char.map { |c| MAP[c] || c.to_i }
end

def to_string(array)
  array.map { |n| MAP_INVERT[n] || n.to_i }.join("")
end

def reduce(array)
  puts to_string(array) if DEBUG >= 1
  depth = 0
  array.each_with_index do |c, i|
    depth += DEPTH[c] || 0
    if depth > 4
      puts "explode #{array[i + 1]}, #{array[i + 3]}" if DEBUG >= 2
      (i - 1).downto(0) do |j|
        if array[j] >= 0
          array[j] += array[i + 1]
          break
        end
      end
      ((i + 4)...array.size).each do |j|
        if array[j] >= 0
          array[j] += array[i + 3]
          break
        end
      end
      return reduce(array[0, i] + [0] + array[i + 5, array.size])
    end
    depth
  end
  array.each_with_index do |c, i|
    if c > 9
      puts "split #{c}" if DEBUG >= 2
      a = c / 2
      b = (c + 1) / 2
      return reduce(array[0, i] + [MAP["["], a, MAP[","], b, MAP["]"]] + array[i + 1, array.size])
    end
  end
  array
end

def add(a, b)
  reduce([MAP["["]] + a + [MAP[","]] + b + [MAP["]"]])
end

def magnitude(x)
  if x.is_a?(Array)
    3 * magnitude(x[0]) + 2 * magnitude(x[1])
  else
    x
  end
end

puts(data.permutation(2).map do |(a, b)|
  magnitude(eval(to_string(add(a, b))))
end.max)
puts "Finished in #{Time.now - @start_time} seconds."
