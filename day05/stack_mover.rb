#     [D]
# [N] [C]
# [Z] [M] [P]
#  1   2   3

# move 1 from 2 to 1
# move 3 from 1 to 3
# move 2 from 2 to 1
# move 1 from 1 to 2

module StackMover
  # @stacks = {
  #   1 => ['N', 'Z'],
  #   2 => ['D', 'C', 'M'],
  #   3 => ['P']
  # }
  @stacks = {}
  @loading_stacks = true

  def self.move(filepath = 'test_input.txt', part = 1)
    File.readlines(filepath).each do |line|
      formatted_line = line.rstrip

      if @loading_stacks
        load_stacks(formatted_line)
      else
        move_boxes(formatted_line, part)
      end
    end
    puts @stacks.sort_by{ |stack_number, _| stack_number }.map { |stack_number, contents| contents.last }.join
  end

  def self.move_boxes(line, part)
    number, from_stack, to_stack = line.scan(/\d+/).map(&:to_i)

    case part
    when 1 then number.times { @stacks[to_stack] << @stacks[from_stack].pop }
    when 2 then @stacks[to_stack] += @stacks[from_stack].pop(number)
    end
  end

  def self.load_stacks(line)
    if line.empty? # we've finished reading in the initial config, time to move boxes
      @loading_stacks = false
    elsif line.lstrip[0] == '[' # loading boxes
      load_boxes(line)
    elsif line =~ /\A[\d|\s]+\z/ # ensure all stack locations initialized
      line.scan(/\d/).each do |i|
        @stacks[i.to_i] ||= []
      end
    end
  end

  def self.load_boxes(line)
    (0...line.length).each do |i| # look for box locations
      if line[i] == '[' # box found!
        stack_number = (i + 4) / 4
        @stacks[stack_number] ||= []
        @stacks[stack_number].prepend(line[i + 1]) # move the letter onto the beginning (bottom) of this stack
      end
    end
  end
end

StackMover.move('input.txt', 2)
