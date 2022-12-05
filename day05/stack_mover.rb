#     [D]
# [N] [C]
# [Z] [M] [P]
#  1   2   3

# move 1 from 2 to 1
# move 3 from 1 to 3
# move 2 from 2 to 1
# move 1 from 1 to 2

require 'pry'
module StackMover
  # @stacks = {
  #   1 => ['N', 'Z'],
  #   2 => ['D', 'C', 'M'],
  #   3 => ['P']
  # }
  @stacks = {}
  @loading_stacks = true

  def self.move(filepath = 'test_input.txt')
    File.readlines(filepath).each do |line|
      formatted_line = line.rstrip

      if @loading_stacks # Reading in initial config of the stacks
        load_stacks(formatted_line)
      else # moving boxes
        move_boxes(formatted_line)
      end
    end
    puts @stacks.sort_by{ |stack_number, _| stack_number }.map { |stack_number, contents| contents.last }.join
  end

  def self.move_boxes(line)
    number, from_stack, to_stack = line.scan(/\d+/).map(&:to_i)

    # Take it from the front first
    number.times { @stacks[to_stack] << @stacks[from_stack].pop }
  end

  def self.load_stacks(line)
    if line.empty? # we've finished reading in the initial config, time to move boxes
      @loading_stacks = false
    elsif line.lstrip[0] == '[' # loading boxes
      (0...line.length).each do |i|
        if line[i] == '[' # box found!
          stack_number = (i + 4) / 4
          @stacks[stack_number] ||= []
          @stacks[stack_number].prepend(line[i + 1]) # move the letter onto the beginning (bottom) of this stack
        end
      end
    elsif line =~ /\A[\d|\s]+\z/ # setting stack locations
      # Make sure to convert to int!
      line.scan(/\d/).each do |i|
        @stacks[i.to_i] ||= []
      end
    end
  end
end

StackMover.move('test_input.txt')
