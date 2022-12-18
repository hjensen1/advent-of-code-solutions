require '../util.rb'

OCCUPIED = Set.new([[0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0]])

class Rock
  attr_accessor :points
  
  def initialize(points)
    @points = points
  end

  def down(validate = true)
    points.each do |point|
      point[1] -= 1
    end
    if validate && blocked?
      up(false)
      true
    end
  end

  def up(validate = true)
    points.each do |point|
      point[1] += 1
    end
    if validate && blocked?
      down(false)
    end
  end

  def left(validate = true)
    points.each do |point|
      point[0] -= 1
    end
    if validate && blocked?
      right(false)
    end
  end

  def right(validate = true)
    points.each do |point|
      point[0] += 1
    end
    if validate && blocked?
      left(false)
    end
  end

  def blocked?
    points.any? { |p| OCCUPIED.include?(p) || p[0] < 0 || p[0] > 6 }
  end
end

class Row < Rock
  def initialize(left, bottom)
    super([[left, bottom], [left+1, bottom], [left+2, bottom], [left+3, bottom]])
  end
end

class T < Rock
  def initialize(left, bottom)
    super([[left + 1, bottom + 2], [left, bottom + 1], [left+1, bottom+1], [left+2, bottom+1], [left+1, bottom]])
  end
end

class J < Rock
  def initialize(left, bottom)
    super([[left + 2, bottom + 2], [left + 2, bottom + 1], [left, bottom], [left+1, bottom], [left+2, bottom]])
  end
end

class I < Rock
  def initialize(left, bottom)
    super([[left, bottom + 3], [left, bottom + 2], [left, bottom + 1], [left, bottom]])
  end
end

class Square < Rock
  def initialize(left, bottom)
    super([[left, bottom + 1], [left + 1, bottom + 1], [left, bottom], [left + 1, bottom]])
  end
end

jets = File.read('./17.txt').chomp.split("")
rocks = [Row, T, J, I, Square]
height = 0
shapes = { 0 => { [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0]] => [0, 0] } }

start_index, start_height, start_shape, end_index, end_height = nil, nil, nil, nil, nil
(1..1000000000000).each do |i|
  klass = rocks.shift
  rocks << klass
  rock = klass.new(2, height + 4)
  loop do
    jet = jets.shift
    jets << jet
    jet == '>' ? rock.right : rock.left
    # p rock.points.last
    done = rock.down
    # p rock.points.last
    if done
      rock.points.each do |x, y|
        OCCUPIED << [x, y]
        height = y if y >= height
      end
      break
    end
  end

  shape = Set.new
  empty = Set.new
  queue = (0..6).map { |x| [x, height] }
  while !queue.empty?
    point = queue.pop
    x, y = point
    if OCCUPIED.include?(point)
      shape << [x, y - height]
    elsif !empty.include?(point)
      empty << point
      queue << [x - 1, y] if x > 0
      queue << [x + 1, y] if x < 6
      queue << [x, y - 1]
    end
  end
  index = i % (jets.size * 5)
  shapes[index] ||= {}
  if shapes[index][shape]
    start_index, start_height = shapes[index][shape]
    start_shape = shape
    end_index = i
    end_height = height
    break
  else
    shapes[index][shape] = [i, height]
  end
end

((height-15)..height).to_a.reverse.each do |y|
  (0..6).each do |x|
    if OCCUPIED.include?([x, y])
      print "#"
    else
      print "."
    end
  end
  puts
end

p [start_index, end_index, start_height, end_height, start_shape]
steps = 1000000000000
cycle_length = end_index - start_index
cycle_height = end_height - start_height
height = steps / cycle_length * cycle_height + start_height
remaining_steps = (steps - steps / cycle_length * cycle_length - start_index)

OCCUPIED.clear
start_shape.each do |x, y|
  OCCUPIED << [x, height + y]
end

((height-15)..height).to_a.reverse.each do |y|
  (0..6).each do |x|
    if OCCUPIED.include?([x, y])
      print "#"
    else
      print "."
    end
  end
  puts
end

remaining_steps.times do |i|
  klass = rocks.shift
  rocks << klass
  rock = klass.new(2, height + 4)
  loop do
    jet = jets.shift
    jets << jet
    jet == '>' ? rock.right : rock.left
    # p rock.points.last
    done = rock.down
    # p rock.points.last
    if done
      rock.points.each do |x, y|
        OCCUPIED << [x, y]
        height = y if y >= height
      end
      break
    end
  end
end

puts height

puts "Finished in #{Time.now - @start_time} seconds."
