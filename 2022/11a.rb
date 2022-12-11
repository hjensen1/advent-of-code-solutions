require '../util.rb'

Monkey = Struct.new(:items, :operation, :arg, :test, :true_throw, :false_throw, :inspections)

result = 0
monkeys = []
monkey = nil
File.read('./11.txt').split("\n").each do |line|
  if line["Monkey "]
    monkeys << Monkey.new([], nil, nil, nil, nil, nil, 0)
    monkey = monkeys.last
  elsif line["Starting "]
    monkey.items = line.split(": ").last.split(", ").map(&:to_i)
  elsif line["Operation: "]
    operation, arg = line.split(' ').last(2)
    monkey.operation = operation.to_sym
    monkey.arg = arg == "old" ? arg : arg.to_i
  elsif line["Test:"]
    monkey.test = line.split(" ").last.to_i
  elsif line["If true"]
    monkey.true_throw = line.split(" ").last.to_i
  elsif line["If false"]
    monkey.false_throw = line.split(" ").last.to_i
  end
end

20.times do |round|
  monkeys.each do |monkey|
    while monkey.items.size > 0
      monkey.inspections += 1
      item = monkey.items.shift
      item = item.send(monkey.operation, monkey.arg == "old" ? item : monkey.arg)
      item /= 3
      if item % monkey.test == 0
        monkeys[monkey.true_throw].items << item
      else
        monkeys[monkey.false_throw].items << item
      end
    end
  end
end

puts monkeys.map(&:inspections).sort.last(2).reduce(:*)
puts "Finished in #{Time.now - @start_time} seconds."
