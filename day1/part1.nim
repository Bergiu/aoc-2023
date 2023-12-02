import strutils
import sequtils
import math

var example_input = """1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
"""


proc toNumbers(input: string): seq[int] =
  for line in input.splitLines():
    var digits = filter(line, isDigit)
    if digits.len == 0: continue
    result.add parseInt(digits[0] & digits[^1])


proc test() =
  var numbers = toNumbers(example_input)
  assert numbers == @[12, 38, 15, 77]
  var summed = sum(numbers)
  assert summed == 142


proc main() =
  echo "Task1"
  test()
  var input = readFile("input.txt")
  var numbers = toNumbers(input)
  var summed = sum(numbers)
  echo summed


if isMainModule:
  main()
