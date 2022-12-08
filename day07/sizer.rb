require "pry"
module Sizer
  @dirs = {}
  @current_directory = nil

  class Directory
    attr_accessor :name, :parent, :files, :children

    def initialize(attrs = {})
      self.name = attrs[:name]
      self.parent = attrs[:parent]
      self.files = attrs.fetch(:files, [])
      self.children = attrs.fetch(:children, [])
    end

    def size_sum
      files.sum(&:size) + children.sum(&:size_sum)
    end
  end

  class File
    attr_accessor :name, :parent, :size

    def initialize(attrs = {})
      self.name = attrs[:name]
      self.parent = attrs[:parent]
      self.size = attrs[:size]
    end
  end

  def self.run(filepath = 'test_input.txt')
    populate_dirs(filepath)
    puts size_sum_of_dirs_with_size_at_most(100000)
  end

  def self.size_sum_of_dirs_with_size_at_most(max_size)
    @dirs.values.map { |dir| dir.size_sum }.reject { |size_sum| size_sum > max_size}.sum
  end

  def self.populate_dirs(filepath = 'test_input.txt')
    ::File.readlines(filepath).each do |line|
      puts line
      formatted_line = line.split
      case formatted_line[0]
      when "$" # command
        case formatted_line[1]
        when "cd"
          process_cd(formatted_line[2])
        when "ls"
          next
        end
      when "dir" # listing a directory
        find_or_create_directory(formatted_line[1])
      when /\d+/
        find_or_create_file(formatted_line[0], formatted_line[1])
      end
    end
  end

  def self.process_cd(dir_name)
    if dir_name == ".."
      @current_directory = @current_directory.parent || @current_directory # in case they're already at root
    else
      dir = find_or_create_directory(dir_name)
      @current_directory = dir
    end
  end

  def self.find_or_create_directory(dir_name)
    dir = @dirs[dir_name] || Directory.new(name: dir_name, parent: @current_directory)
    @dirs[dir_name] ||= dir
    @current_directory.children << dir if @current_directory
    dir
  end

  def self.find_or_create_file(file_size, file_name)
    return if @current_directory.files.find { |f| f.name == file_name}
    file = File.new(name: file_name, size: file_size.to_i, parent: @current_directory)
    @current_directory.files << file
  end
end

Sizer.run("input.txt")
