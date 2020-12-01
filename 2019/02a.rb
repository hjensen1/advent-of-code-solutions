def add(list, i)
  list[list[i + 3]] = list[list[i + 2]] + list[list[i + 1]]
end

def multiply(list, i)
  list[list[i + 3]] = list[list[i + 2]] * list[list[i + 1]]
end

def evaluate(list)
  list[1] = 12
  list[2] = 2
  i = 0
  loop do
    if list[i] == 99
      return list[0]
    elsif list[i] == 1
      add(list, i)
    elsif list[i] == 2
      multiply(list, i)
    else
      raise "Bad code #{list[i]} at index #{i}"
    end
    i += 4
  end
end

File.readlines('./02.txt').each do |line|
  list = line.split(',').map(&:to_i)
  puts evaluate(list)
end
