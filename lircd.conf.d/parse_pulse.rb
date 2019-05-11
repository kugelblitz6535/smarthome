def parse(dir)
  str = ''
  Dir.foreach(dir.to_s) do |f|
    unless f.start_with?('.')
      str += "name #{f}\n"
      lines = File.open("#{dir}/#{f}").readlines
      lines_without_first = lines.slice(1..-1)
      codes = lines_without_first.map { |line| line.split(' ')[1] }
      codes.each_slice(6) do |c|
        str += c.join(' ') + "\n"
      end
    end
    str += "\n"
  end
  str
end

puts <<-EOS
begin remote

  name  #{ARGV[0]}
  flags RAW_CODES
  eps            30
  aeps          100

  gap          200000
  toggle_bit_mask 0x0

      begin raw_codes
        #{parse(ARGV[0])}
      end raw_codes

end remote
EOS
