module CalorieCounting
  @elf_calories = {}

  def self.run(filepath = 'input.txt')
    populate_elf_calories(filepath)
    total_calories_carried_by_top_n_elves(3)
  end

  def self.total_calories_carried_by_top_n_elves(num = 1)
    puts @elf_calories
      .sort_by{ |elf,calories| -calories }
      .first(num)
      .inject(0) { |sum, (elf, calories)| sum + calories }
  end

  def self.populate_elf_calories(filepath)
    elf = 0
    File.readlines(filepath).each do |line|
      if line == "" || line == "\n"
        elf += 1
      else
        @elf_calories[elf] ||= 0
        @elf_calories[elf] += line.to_i
      end
    end
  end
end

# CalorieCounting.run('test_input.txt')
CalorieCounting.run('input.txt')
