defmodule Sizer do
  defmodule Directory do
    defstruct [:parent, :children, :name, :files]
  end

  defmodule AFile do
    defstruct [:parent, :name, :size]
  end

  # Example:
  # dirs = {
  #   "/" => 48381165
  #   "a" => 94853
  #   "e" => 584
  #   "d" => 24933642
  # }

  def run(filepath \\ "test_input.txt") do
    dirs = populate_dirs_for_file(filepath)
    IO.inspect dirs
  end

  def populate_dirs_for_file(filepath) do
    File.read!(filepath)
    |> String.split("\n")
    |> populate_dirs()
  end

  ######## populate_dirs
  defp populate_dirs([line | remaining_lines]) do # Before there is a current_directory
    {current_directory, dirs} = String.split(line) |> process_line_parts(%{}, nil)

    populate_dirs(remaining_lines, dirs, current_directory)
  end
  defp populate_dirs([line | remaining_lines], dirs, current_directory) do
    IO.puts("LINE: #{line}")
    {current_directory, dirs} = String.split(line) |> process_line_parts(dirs, current_directory)

    populate_dirs(remaining_lines, dirs, current_directory)
  end

  defp populate_dirs([], dirs, _current_directory), do: dirs

  ######## process_line_parts
  defp process_line_parts([], dirs, current_directory), do: {current_directory, dirs}
  defp process_line_parts(["$", "cd", ".."], dirs, current_directory) do
    {current_directory.parent, dirs}
  end

  defp process_line_parts(["$", "cd", dir_name], dirs, current_directory) do
    find_or_create_dir(dir_name, dirs, current_directory)
  end

  defp process_line_parts(["$", "ls"], dirs, current_directory), do: {current_directory, dirs}

  defp process_line_parts(["dir", dir_name], dirs, current_directory) do
    {_dir, dirs} = find_or_create_dir(dir_name, dirs, current_directory)
    {current_directory, dirs}
  end

  defp process_line_parts([file_size, file_name], dirs, current_directory) do
    file = struct(AFile, parent: current_directory, name: file_name, size: file_size)

    # if file_size == "8504156" do
    # require IEx; IEx.pry
    # end

    case Enum.member?(current_directory.files, file) do
      true -> {current_directory, dirs}
      false ->
        # require IEx; IEx.pry
        {Map.replace(current_directory, :files, [file | current_directory.files]), dirs}
    end
  end

  defp find_or_create_dir(dir_name, %{}, nil) do
    dir = struct(Directory, parent: nil, name: dir_name, children: [], files: [])

    {dir, %{dir_name => dir}}
  end
  defp find_or_create_dir(dir_name, dirs, current_directory) do
    case dirs[dir_name] do
      nil ->
        dir = struct(Directory, parent: current_directory, name: dir_name, children: [], files: [])

        current_directory = Map.put(current_directory, :children, [dir | current_directory.children])

        {dir, Map.put(dirs, dir_name, dir)}
      _dir ->
        {dirs[dir_name], dirs}
    end
  end
end

Sizer.run("test_input.txt")
