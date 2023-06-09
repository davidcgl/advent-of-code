# frozen_string_literal: true

def solve(limit:)
  seen = Set.new
  first = nil
  last = nil

  a2 = 0
  a3 = 0

  limit.times do
    a2 = a3 | 65_536
    a3 = 832_312

    loop do
      a3 += (a2 & 255)
      a3 &= 16_777_215
      a3 *= 65_899
      a3 &= 16_777_215

      if a2 < 256
        if seen.add?(a3)
          if first.nil?
            first = a3
          else
            last = a3
          end
        end
        break
      end

      a2 /= 256
    end
  end

  [first, last]
end

limit = ARGV[0].to_i || 100_000
first, last = solve(limit:)
puts "part one: #{first}"
puts "part two: #{last}"
