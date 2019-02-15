require 'set'

File.open(File.join(__dir__, 'input.txt')) do |file|
  seen = Set.new
  file.each.map(&:strip).each do |word|
    seen.add(word)
    next unless seen.size > 1

    (0...word.size).each do |i|
      ('a'..'z').reject { |c| c == word[i] }.each do |char|
        code = word[0, i] + char + word[i + 1, word.size - i - 1]
        if seen.include?(code)
          puts code
          puts word
          puts ('-' * i) + '^'
          return
        end
      end
    end
  end
end
