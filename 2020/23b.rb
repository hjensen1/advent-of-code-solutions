require '../util.rb'

COUNT = 1_000_000
STEPS = 10_000_000
INPUT = '315679824'

Node = Struct.new(:value, :next) do
  def get_next(count)
    list = []
    node = self.next
    count.times do
      list << node
      node = node.next
    end
    [list, node]
  end

  def to_a
    list = [self.value]
    node = self.next
    while node != self
      list << node.value
      node = node.next
    end
    list
  end
end

@nexts = Array.new(COUNT + 1)

prev = COUNT
(INPUT.split('').map(&:to_i) + (10..COUNT).to_a).each do |cup|
  @nexts[prev] = cup
  prev = cup
end
node = INPUT.split('').first.to_i

STEPS.times do
  next3 = []
  nextnext = @nexts[node]
  3.times do
    next3 << nextnext
    nextnext = @nexts[nextnext]
  end
  target = node - 1
  while next3.include?(target) || target < 1
    target -= 1
    target = COUNT if target < 1
  end

  @nexts[target], @nexts[next3.last] = next3.first, @nexts[target]
  @nexts[node] = nextnext
  node = nextnext
end

p @nexts[1] * @nexts[@nexts[1]]
puts "Finished in #{Time.now - @start_time} seconds."
