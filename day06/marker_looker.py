class MarkerLooker:
  def __init__(self, filepath, part):
    self.min_distinct_length = 4 if part == 1 else 14
    with open(filepath) as fp:
      line = fp.readline().strip()
      self.datastream = list(line)

  def number_of_characters_to_find_marker(filepath, part):
    marker_looker = MarkerLooker(filepath, part)

    for idx, c in enumerate(marker_looker.datastream):
      position = idx + 1
      if marker_looker.is_marker(marker_looker.datastream[(position-marker_looker.min_distinct_length):position]):
        return position

  # It's a marker if the last 4 characters were all different
  def is_marker(self, last_four_characters):
    return len(set(last_four_characters)) == self.min_distinct_length

### TESTS
print("TEST: should equal 7")
print(MarkerLooker.number_of_characters_to_find_marker('test_input1.txt', 1))

print("TEST: should equal 5")
print(MarkerLooker.number_of_characters_to_find_marker('test_input2.txt', 1))

print("TEST: should equal 6")
print(MarkerLooker.number_of_characters_to_find_marker('test_input3.txt', 1))

print("TEST: should equal 10")
print(MarkerLooker.number_of_characters_to_find_marker('test_input4.txt', 1))

print("TEST: should equal 11")
print(MarkerLooker.number_of_characters_to_find_marker('test_input5.txt', 1))

print("Part 1")
print(MarkerLooker.number_of_characters_to_find_marker('input.txt', 1))

print("-------------------------")

print("TEST: should equal 19")
print(MarkerLooker.number_of_characters_to_find_marker('test_input1.txt', 2))

print("TEST: should equal 23")
print(MarkerLooker.number_of_characters_to_find_marker('test_input2.txt', 2))

print("TEST: should equal 23")
print(MarkerLooker.number_of_characters_to_find_marker('test_input3.txt', 2))

print("TEST: should equal 29")
print(MarkerLooker.number_of_characters_to_find_marker('test_input4.txt', 2))

print("TEST: should equal 26")
print(MarkerLooker.number_of_characters_to_find_marker('test_input5.txt', 2))

print("Part 2")
print(MarkerLooker.number_of_characters_to_find_marker('input.txt', 2))
