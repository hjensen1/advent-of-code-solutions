require '../util.rb'

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
    points.any? { |p| Solver.occupied.include?(p) || p[0] < 0 || p[0] > 6 }
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

class Solver
  MAX = 1000000000000

  attr_accessor :jets, :rocks, :height, :shapes, :jet_count, :rock_count, :occupied,
    :start_jet, :end_jet, :start_rock, :end_rock, :start_height, :end_height

  def initialize
    @jets = File.read('./17.txt').chomp.split("")
    @rocks = [Row, T, J, I, Square]
    @height = 0
    @jet_count = 0
    @rock_count = 0
    floor = [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0]]
    @shapes = { 0 => { floor => [0, 0, 0] } }
    @occupied = Set.new(floor)
    self.class.occupied = occupied
  end

  class << self
    attr_accessor :occupied
  end

  def execute
    puts "drop_rocks"
    drop_rocks { check_for_cycle }
    puts "skip_ahead"
    skip_ahead
    puts "drop_rocks"
    drop_rocks
    height
  end

  def drop_rocks(&block)
    while rock_count < MAX
      drop_rock
      if block
        done = yield
        return if done
      end
    end
  end

  def drop_rock(&block)
    rock = rocks[rock_count % 5].new(2, height + 4)
    loop do
      jet = jets[jet_count % jets.size]
      @jet_count += 1
      jet == '>' ? rock.right : rock.left
      done = rock.down
      if done
        rock.points.each do |x, y|
          occupied << [x, y]
          @height = y if y >= height
        end
        break
      end
    end
    @rock_count += 1
  end

  def check_for_cycle
    shape = compute_top_shape
    jet_mod = jet_count % jets.size
    rock_mod = rock_count % 5
    shapes[jet_mod] ||= {}
    past_shapes = (shapes[jet_mod][rock_mod] ||= {})
    if past_shapes[shape]
      @start_jet, @start_rock, @start_height = past_shapes[shape]
      @end_jet = jet_count
      @end_rock = rock_count
      @end_height = height
      true
    else
      past_shapes[shape] = [jet_count, rock_count, height]
      false
    end
  end

  def compute_top_shape
    new_occupied = Set.new
    shape = Set.new
    empty = Set.new
    stack = (0..6).map { |x| [x, height] }
    while !stack.empty?
      point = stack.pop
      x, y = point
      if occupied.include?(point)
        shape << [x, y - height]
        new_occupied << point
      elsif !empty.include?(point)
        empty << point
        stack << [x - 1, y] if x > 0
        stack << [x + 1, y] if x < 6
        stack << [x, y - 1]
      end
    end
    @occupied = new_occupied
    self.class.occupied = new_occupied
    shape
  end

  def skip_ahead
    p [start_jet, end_jet, start_rock, end_rock, start_height, end_height]
    cycle_jets = end_jet - start_jet
    cycle_rocks = end_rock - start_rock
    cycle_height = end_height - start_height
    cycle_count = (MAX - end_rock) / cycle_rocks # already went through one cycle
    @height += cycle_count * cycle_height
    @jet_count += cycle_count * cycle_jets
    @rock_count += cycle_count * cycle_rocks
    new_occupied = Set.new
    occupied.each do |x, y|
      new_occupied << [x, y + cycle_count * cycle_height]
    end
    @occupied = new_occupied
    self.class.occupied = occupied
  end

  def print_top
    ((height-15)..height).to_a.reverse.each do |y|
      (0..6).each do |x|
        if occupied.include?([x, y])
          print "#"
        else
          print "."
        end
      end
      puts
    end
    puts
    puts
  end
end



puts Solver.new.execute

puts "Finished in #{Time.now - @start_time} seconds."
