def add(list, i)
  list[list[i + 3]] = list[list[i + 2]] + list[list[i + 1]]
end

def multiply(list, i)
  list[list[i + 3]] = list[list[i + 2]] * list[list[i + 1]]
end

def evaluate(list)
  i = 0
  loop do
    if list[i] == 99
      return list[0]
    elsif list[i] == 1
      add(list, i)
    elsif list[i] == 2
      multiply(list, i)
    else
      puts "Bad code #{list[i]} at index #{i}"
      return false
    end
    i += 4
  end
end

File.readlines('./02.txt').each do |line|
  list = line.split(',').map(&:to_i)
  (0..99).each do |noun|
    (0..99).each do |verb|
      dup = list.dup
      dup[1] = noun
      dup[2] = verb
      if evaluate(dup) == 19690720
        puts 100 * noun + verb
      end
    end
  end
end
