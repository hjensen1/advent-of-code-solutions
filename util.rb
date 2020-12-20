def to_point(x, y)
  "#{x},#{y}"
end

def from_point(point)
  point.split(',').map(&:to_i)
end

@start_time = Time.now
