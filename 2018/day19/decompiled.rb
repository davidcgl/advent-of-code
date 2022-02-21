# frozen_string_literal: true

# A rough translation of program in input.txt

a0 = 1
a1 = 0
a2 = 0
a3 = 0
a4 = 0

# Instruction 17-39
a2 += 2
a2 *= 2
a2 *= 19 # ip 19
a2 *= 11
a4 += 8
a4 *= 22 # ip 22
a4 += 20
a2 += a4

if a0 == 1
  a4 = 27 # ip 27
  a4 *= 28 # ip 28
  a4 += 29 # ip 29
  a4 *= 30 # ip 30
  a4 *= 14
  a4 *= 32 # ip 32
  a2 += a4
  a0 = 0
end

a1 = 1
a3 = 1

# Instruction 1-16
loop do
  a4 = a1 * a3

  if a4 == a2
    a0 += a3
  end

  a1 += 1
  if a1 <= a2
    next
  end

  a3 += 1
  if a3 > a2
    break
  end

  a1 = 1
end
