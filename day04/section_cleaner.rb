module SectionCleaner

  # 2-4,6-8
  # 2-3,4-5
  # 5-7,7-9
  # 2-8,3-7
  # 6-6,4-6
  # 2-6,4-8
  def self.contained_count(filepath = 'test_input.txt', part = 1)
    contained_count = 0

    File.readlines(filepath).each do |line|
      sections = line.strip.split(/,|-/)
      elf1_sections = (sections[0].to_i..sections[1].to_i)
      elf2_sections = (sections[2].to_i..sections[3].to_i)

      case part
        when 1
          contained_count += 1 if part1_should_increment?(elf1_sections, elf2_sections)
        when 2
          contained_count += 1 if part2_should_increment?(elf1_sections, elf2_sections)
      end
    end
    puts contained_count
  end

  def self.part1_should_increment?(elf1_sections, elf2_sections)
    elf1_sections.cover?(elf2_sections) || elf2_sections.cover?(elf1_sections)
  end

  # Range in Rails has "overlaps?" method
  def self.part2_should_increment?(elf1_sections, elf2_sections)
    !(elf1_sections.min > elf2_sections.max || elf1_sections.max < elf2_sections.min)
  end
end

SectionCleaner.contained_count('input.txt', 2)