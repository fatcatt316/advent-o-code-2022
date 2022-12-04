module Rucksack
  @rucksacks = {}
  @letters_by_priority = ('a'..'z').to_a + ('A'..'Z').to_a

  def self.part1(filepath = 'test_input.txt')
    File.readlines(filepath).each_with_index do |line, i|
      @rucksacks[i] = {}

      compartment_length = line.length / 2

      @rucksacks[i][1] = line[0...compartment_length].scan(/\w/)
      @rucksacks[i][2] = line[compartment_length..].scan(/\w/)

      @rucksacks[i][:shared] = @rucksacks[i][1].intersection(@rucksacks[i][2]).first
      @rucksacks[i][:priority] = letter_priority(@rucksacks[i][:shared])
    end
    puts @rucksacks.sum { |num, rucksack| rucksack[:priority] }
  end

  def self.part2(filepath = 'test_input.txt')
    File.readlines(filepath).each_with_index do |line, i|
      @rucksacks[i] = {contents: line.scan(/\w/)}

      if (i + 1) % 3 == 0 # then it's the last of a group of three
        @rucksacks[i][:badge] = @rucksacks[i - 2][:contents]
          .intersection(@rucksacks[i - 1][:contents])
          .intersection(@rucksacks[i][:contents])
          .first

        @rucksacks[i][:priority] = letter_priority(@rucksacks[i][:badge])
      end
    end
    puts @rucksacks.sum { |num, rucksack| rucksack[:priority].to_i }
  end

  # Lowercase item types a through z have priorities 1 through 26.
  # Uppercase item types A through Z have priorities 27 through 52.
  def self.letter_priority(letter)
    @letters_by_priority.index(letter) + 1
  end
end

Rucksack.part2('input.txt')