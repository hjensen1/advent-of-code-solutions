require '../util.rb'

def get_id(x, y, z, w)
  result = x + (64 * (y + 64 * (z + (64 * w))))
end

Cell = Struct.new(:x, :y, :z, :w, :active, :neighbors) do
  def id
    @id ||= get_id(x, y, z, w)
  end
end

cells = {}
r = 0
File.read('./17.txt').split("\n").each do |line|
  i = 0
  line.each_char do |char|
    cell = Cell.new(i, r, 0, 0, char == '#', 0)
    cells[cell.id] = cell
    i += 1
  end
  r += 1
end

6.times do
  cells.values.each { |cell| cell.neighbors = 0 }
  cells.values.each do |cell|
    if cell.active
      ((cell.w-1)..(cell.w+1)).each do |w|
        ((cell.x-1)..(cell.x+1)).each do |x|
          ((cell.y-1)..(cell.y+1)).each do |y|
            ((cell.z-1)..(cell.z+1)).each do |z|
              id = get_id(x, y, z, w)
              next if id == cell.id
              cells[id] ||= Cell.new(x, y, z, w, false, 0)
              cells[id].neighbors += 1
            end
          end
        end
      end
    end
  end
  cells.values.each do |cell|
    if cell.active
      cell.active = false if cell.neighbors < 2 || cell.neighbors > 3
    else
      cell.active = true if cell.neighbors == 3
    end
  end
end

puts cells.values.count { |cell| cell.active }
puts "Finished in #{Time.now - @start_time} seconds."
