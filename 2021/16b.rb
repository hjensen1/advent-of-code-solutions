require '../util.rb'

string = ""
File.read('./16.txt').split("\n").each do |line|
  string = line.to_i(16).to_s(2)
  string = string.rjust(line.size * 4, "0")
end
# puts string

@total = 0

@operations = { 0 => "+", 1 => "*", 2 => "min", 3 => "max", 5 => ">", 6 => "<", 7 => "=" }

def decode_packet(string, depth = 0)
  # puts string
  version = string[0, 3].to_i(2)
  type_id = string[3, 3].to_i(2)
  # puts "version #{version} type_id #{type_id}"
  @total += version
  body = string[6, string.size]
  value = 0
  if type_id == 4
    value = ""
    loop do
      stop = body[0] == "0"
      value << body[1, 4]
      body = body[5, body.size]
      break if stop
    end
    value = value.to_i(2)
    # puts "literal #{value}"
    print "  " * depth
    puts value
  else
    length_type_id = body[0]
    sub_values = []
    print "  " * depth
    puts "#{@operations[type_id]}("
    if length_type_id == "0"
      sub_size = body[1, 15].to_i(2)
      body = body[16, body.size] || ""
      original_size = body.size
      operator = 
      while original_size - body.size < sub_size
        body, sub_value = decode_packet(body, depth + 1)
        sub_values << sub_value
      end
    else
      sub_count = body[1, 11].to_i(2)
      body = body[12, body.size]
      sub_count.times do
        body, sub_value = decode_packet(body, depth + 1)
        sub_values << sub_value
      end
    end
    print "  " * depth
    puts ")"

    if type_id == 0
      value = sub_values.sum
    elsif type_id == 1
      value = sub_values.reduce(&:*)
    elsif type_id == 2
      value = sub_values.min
    elsif type_id == 3
      value = sub_values.max
    elsif type_id == 5
      value = sub_values[0] > sub_values[1] ? 1 : 0
    elsif type_id == 6
      value = sub_values[0] < sub_values[1] ? 1 : 0
    elsif type_id == 7
      value = sub_values[0] == sub_values[1] ? 1 : 0
    end
  end
  [body, value]
end

s, v = decode_packet(string)
puts v

puts "Finished in #{Time.now - @start_time} seconds."
