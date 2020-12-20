require '../util.rb'
require 'set'

Cell = Struct.new(:id, :edges, :data) do
  def rotate(x)
    top, right, bottom, left = edges
    x.times do
      right, bottom, left, top = [
        top, right.reverse, bottom, left.reverse
      ]
    end
    self.edges = [top, right, bottom, left]
    return self
  end

  def flip(type)
    if type == 'h'
      top, right, bottom, left = edges
      self.edges = [top.reverse, left, bottom.reverse, right]
    elsif type == 'v'
      top, right, bottom, left = edges
      self.edges = [bottom, right.reverse, top, left.reverse]
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

def get_edges(tile)
  [
    tile.first,
    tile.map { |s| s[s.size - 1] }.join(''),
    tile.last,
    tile.map { |s| s[0] }.join(''),
  ]
end

@edges_to_ids = Hash.new { |h, k| h[k] = [] }
@cells.each_pair do |id, tile|
  edges = get_edges(tile)
  @cells[id] = Cell.new(id, edges, tile)
  (edges + edges.map(&:reverse)).each do |edge|
    @edges_to_ids[edge] << id
  end
end

first_id = @cells.first[0]

@solved = {}

def place(cell, x, y)
  @solved[to_point(x, y)] = cell
  p [x, y, cell]
  [[x, y+1], [x+1, y], [x, y-1], [x-1, y]].each_with_index do |coords, index|
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

puts [@solved[to_point(minx, miny)], @solved[to_point(minx, maxy)], @solved[to_point(maxx, miny)], @solved[to_point(maxx, maxy)]].map(&:id).reduce(1) { |p, v| p * v }
puts "Finished in #{Time.now - @start_time} seconds."
