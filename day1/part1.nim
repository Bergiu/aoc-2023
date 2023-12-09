import strutils
import sequtils
import math

const exampleInput = """1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
"""


func toNumbers(input: string): seq[int] =
  for line in input.splitLines():
    let digits = filter(line, isDigit)
    if digits.len == 0: continue
    result.add parseInt(digits[0] & digits[^1])


func test() =
  let numbers = toNumbers(exampleInput)
  assert numbers == @[12, 38, 15, 77]
  let summed = sum(numbers)
  assert summed == 142


proc main() =
  test()
  let input = readFile("input.txt")
  let numbers = toNumbers(input)
  let summed = sum(numbers)
  echo summed


if isMainModule:
  main()
