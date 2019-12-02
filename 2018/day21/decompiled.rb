# A rough translation of program in input.txt

a0 = 0
a1 = 0
a2 = 0
a3 = 0
a4 = 0

loop do
  a3 = 123
  a3 &= 456
  a3 = a3 == 72 ? 1 : 0
  break if a3 == 1
end

a3 = 0 # ip 5

loop do
  a2 = a3 | 65_536 # ip 6
  a3 = 832_312

  loop do
    a1 = a2 & 255 # ip 8
    a3 += a1
    a3 &= 16_777_215
    a3 *= 65_899
    a3 &= 16_777_215

    a1 = a2 < 256 ? 1 : 0
    if a1 == 1
      return if a3 == a0 # program ends

      break # goto ip 6
    end

    a1 = 0 # ip 17
    loop do
      a4 = a1 + 1
      a4 *= 256
      a4 = a4 > a2 ? 1 : 0
      if a4 == 1
        a2 = a1
        break # goto ip 8
      end
      a1 += 1
    end
  end
end
