require '../util.rb'

string = ""
File.read('./16.txt').split("\n").each do |line|
  string = line.to_i(16).to_s(2)
  string = string.rjust(line.size * 4, "0")
end

@total = 0

def decode_packet(string)
  puts string
  version = string[0, 3].to_i(2)
  type_id = string[3, 3].to_i(2)
  puts "version #{version} type_id #{type_id}"
  @total += version
  body = string[6, string.size]
  if type_id == 4
    size = 6
    value = ""
    loop do
      stop = body[0] == "0"
      value << body[0, 5]
      body = body[5, body.size]
      size += 5
      break if stop
    end
    puts "literal #{value.to_i(2)}"
  else
    length_type_id = body[0]
    if length_type_id == "0"
      sub_size = body[1, 15].to_i(2)
      puts "sub_size #{sub_size}"
      body = body[16, body.size] || ""
      original_size = body.size
      while original_size - body.size < sub_size
        body = decode_packet(body)
      end
    else
      sub_count = body[1, 11].to_i(2)
      puts "sub_count #{sub_count}"
      body = body[12, body.size]
      sub_count.times do
        body = decode_packet(body)
      end
    end
  end
  puts
  body
end

decode_packet(string)
puts @total

puts "Finished in #{Time.now - @start_time} seconds."
