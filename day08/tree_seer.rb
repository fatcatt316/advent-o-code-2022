module TreeSeer
  extend self

  MAX_HEIGHT = 9

  @gigantic_tree_matrix = []
  @tallest_tree_per_column_from_top
  @visible_tree_coordinates = {}

  def run(filepath = 'test_input.txt')
    populate_gigantic_tree_matrix(filepath)
    count_visible_from_the_bottom_up

    puts @visible_tree_coordinates.map{|row, tree_hash| tree_hash.keys.size}.sum
  end

  def find_highest_scenic_score(filepath = 'test_input.txt')
    populate_gigantic_tree_matrix(filepath)
    puts highest_scenic_score
  end

  def highest_scenic_score
    highest_scenic_score_so_far = -1
    (0...@gigantic_tree_matrix.size).each do |row|
      (0...@gigantic_tree_matrix.first.size).each do |col|
        scenic_score = num_visible(:right, row, col) * num_visible(:left, row, col) * num_visible(:up, row, col) * num_visible(:down, row, col)
        next unless scenic_score > highest_scenic_score_so_far

        highest_scenic_score_so_far = scenic_score
      end
    end
    highest_scenic_score_so_far
  end

  def next_tree_height(num, direction, row, col)
    case direction
    when :left
      col = col-num
      return nil if col.negative?
      @gigantic_tree_matrix.dig(row, col)
    when :right then @gigantic_tree_matrix.dig(row, col+num)
    when :up
      row = row-num
      return nil if row.negative?
      @gigantic_tree_matrix.dig(row, col)
    when :down then @gigantic_tree_matrix.dig(row+num, col)
    end
  end

  def num_visible(direction, row, col)
    num = 0
    height = @gigantic_tree_matrix[row][col]
    other_height = next_tree_height(num+1, direction, row, col)
    while other_height
      num += 1
      break unless height > other_height

      other_height = next_tree_height(num+1, direction, row, col)
    end
    num
  end

  def count_visible_from_the_bottom_up
    tallest_tree_per_column_from_bottom = @gigantic_tree_matrix.last.size.times.map { |i|  -1 }

    bottom_row = @gigantic_tree_matrix.size - 1
    (-bottom_row..0).each do |neg_row|
      row = neg_row * -1
      @gigantic_tree_matrix[row].each_with_index do |height, column|
        next unless height > tallest_tree_per_column_from_bottom[column]

        tallest_tree_per_column_from_bottom[column] = height
        @visible_tree_coordinates[row][column] = true
      end
    end
  end

  def count_visible_from_top(tree_heights, row)
    tree_heights.each_with_index do |height, column|
      next unless height > @tallest_tree_per_column_from_top[column]

      @tallest_tree_per_column_from_top[column] = height
      @visible_tree_coordinates[row][column] = true
    end
  end

  def populate_gigantic_tree_matrix(filepath)
    tree_heights = []
    ::File.readlines(filepath).each_with_index do |line, row|
      tree_heights = line.scan(/\d/).map(&:to_i)
      @visible_tree_coordinates[row] = {}

      if row == 0 # all trees in top row are visible
        @tallest_tree_per_column_from_top = tree_heights
        tree_heights.size.times do |i|
          @visible_tree_coordinates[row][i] = true
        end
      else
        count_visible_from_top(tree_heights, row)
        count_visible_from_both_sides(tree_heights, row)
      end
      @gigantic_tree_matrix << tree_heights
    end
  end

  def count_visible_from_top(tree_heights, row)
    tree_heights.each_with_index do |height, column|
      next unless height > @tallest_tree_per_column_from_top[column]

      @tallest_tree_per_column_from_top[column] = height
      @visible_tree_coordinates[row][column] = true
    end
  end

  def count_visible_from_both_sides(tree_heights, row)
    counted_tree_indices = [] # avoid double counting the same tree if it's visible from both sides

    # Check visibility from both sides by reversing it the second time through
    # TODO: Clean this up!
    tallest_tree_on_side = -1
    tree_heights.each_with_index do |height, column|
      next if tallest_tree_on_side == MAX_HEIGHT
      next unless tree_heights[column] > tallest_tree_on_side

      @visible_tree_coordinates[row][column] = true
      tallest_tree_on_side = height
    end

    tallest_tree_on_side = -1
    tree_heights.size.times do |i|
      next if tallest_tree_on_side == MAX_HEIGHT

      column = (tree_heights.size - i) - 1
      height = tree_heights[column]

      next unless height > tallest_tree_on_side

      @visible_tree_coordinates[row][column] = height
      tallest_tree_on_side = height
    end
  end
end

# TreeSeer.run
# TreeSeer.run('input.txt')

TreeSeer.find_highest_scenic_score('input.txt')
