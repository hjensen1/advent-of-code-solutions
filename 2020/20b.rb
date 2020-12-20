require '../util.rb'
require 'set'

def get_edges(tile)
  [
    tile.first,
    tile.map { |s| s[s.size - 1] }.join(''),
    tile.last,
    tile.map { |s| s[0] }.join(''),
  ]
end

Cell = Struct.new(:id, :edges, :data) do
  def rotate(r)
    return self if r == 0
    size = data.size
    result = Array.new(size).map { ' ' * size }
    (0...size).each do |y|
      (0...size).each do |x|
        result[y][x] = data[size - 1 - x][y]
      end
    end
    self.data = result
    self.edges = get_edges(data)
    rotate(r - 1)
  end

  def flip(type)
    if type == 'h'
      self.data = data.map(&:reverse)
      self.edges = get_edges(data)
    elsif type == 'v'
      self.data = data.reverse
      self.edges = get_edges(data)
    end
    return self
  end
end

@cells = {}
File.read('./20.txt').split("\n\n").each do |string|
  lines = string.split("\n")
  id = lines.shift.split(/[ :]/)[1].to_i
  @cells[id] = lines
end

@size = Math.sqrt(@cells.size).to_i

@edges_to_ids = Hash.new { |h, k| h[k] = [] }
@cells.each_pair do |id, tile|
  edges = get_edges(tile)
  @cells[id] = Cell.new(id, edges, tile)
  (edges + edges.map(&:reverse)).each do |edge|
    @edges_to_ids[edge] << id
  end
end

@solved = {}

def place(cell, x, y)
  @solved[to_point(x, y)] = cell
  [[x, y-1], [x+1, y], [x, y+1], [x-1, y]].each_with_index do |coords, index|
    point = to_point(*coords)
    next if @solved[point]

    edge = cell.edges[index]
    match_id = @edges_to_ids[edge].find { |n| n != cell.id }
    next unless match_id
    match = @cells[match_id]
    matched = false
    [0, 1, 2, 3].product([nil, 'h', 'v']).each do |(r, f)|
      match.rotate(r).flip(f)
      if match.edges[0] == edge
        if index == 0
          match.flip('v')
        elsif index == 1
          match.rotate(3).flip('v')
        elsif index == 3
          match.rotate(1)
        end
        place(match, *coords)
        matched = true
        break
      end
      match.flip(f).rotate(4 - r)
    end
    raise 'no match' unless matched
  end
end

place(@cells.first[1], 0, 0)

minx = @solved.keys.map { |s| from_point(s)[0] }.min
maxx = @solved.keys.map { |s| from_point(s)[0] }.max
miny = @solved.keys.map { |s| from_point(s)[1] }.min
maxy = @solved.keys.map { |s| from_point(s)[1] }.max

@image = []
(miny..maxy).each do |y|
  (minx..maxx).each do |x|
    cell = @solved[to_point(x, y)]
    cell.data.shift
    cell.data.pop
    size = cell.data.size
    if x == minx
      (size ).times { @image << '' }
    end
    size.times do |i|
      @image[(y - miny) * (size) + i] += '' + cell.data[i][1, size]
    end
  end
end

pattern = [
  '                  O ',
  'O    OO    OO    OOO',
  ' O  O  O  O  O  O   '
]

def find_pattern(image, pattern)
  width = pattern.first.size
  height = pattern.size
  count = 0
  (0..(image.data.size - height)).each do |y|
    (0..(image.data.size - width)).each do |x|
      matches = true
      (0...height).to_a.product((0...width).to_a).each do |(j, i)|
        if pattern[j][i] == 'O' && image.data[y + j][x + i] != '#'
          matches = false
          break
        end
      end
      if matches
        (0...height).to_a.product((0...width).to_a).each do |(j, i)|
          if pattern[j][i] == 'O'
            image.data[y + j][x + i] = 'O'
          end
        end
        count += 1
      end
    end
  end
  count
end

image = Cell.new(0, get_edges(@image), @image)

[0, 1, 2, 3].product([nil, 'h', 'v']).each do |(r, f)|
  image.rotate(r).flip(f)
  count = find_pattern(image, pattern)
  break if count > 0
  image.flip(f).rotate(4 - r)
end

puts image.data.map { |line| line.gsub('O', "\e[1m\e[32mO\e[0m").gsub('.', "\e[34m.").gsub('#', "\e[36m#") }
puts "\e[0m"

result = 0
image.data.each do |line|
  line.each_char { |char| result += 1 if char == '#' }
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."
