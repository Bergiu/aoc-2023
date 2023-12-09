import strutils
import tables
import math


const exampleInput = """two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
"""

const digitsTable = {
  "0": 0, "1": 1, "2": 2, "3": 3, "4": 4,
  "5": 5, "6": 6, "7": 7, "8": 8, "9": 9,
  "one": 1, "two": 2, "three": 3, "four": 4,
  "five": 5, "six": 6, "seven": 7, "eight": 8, "nine": 9
}.toTable


func firstDigit(line: string): string =
  for i in 0..<line.len:
    # substring from first: hallo -> hallo, allo, llo, lo, o
    let substring = line[i..<line.len]
    for digit in digitsTable.keys:
      if substring.startsWith(digit):
        return digit
  raise newException(Exception, "No digit found in " & line)


func lastDigit(line: string): string =
  for i in 0..<line.len:
    # substring from last: hallo -> hallo, hall, hal, ha, h
    let substring = line[0..<line.len-i]
    for digit in digitsTable.keys:
      if substring.endsWith(digit):
        return digit
  raise newException(Exception, "No digit found in " & line)


func toNumbers(input: string): seq[int] =
  for line in input.splitLines():
    if line.len > 0:
      let first = firstDigit(line)
      let last = lastDigit(line)
      let sum = digitsTable[first]*10 + digitsTable[last]
      result.add(sum)


func test() =
  let numbers = toNumbers(exampleInput)
  assert numbers == @[29, 83, 13, 24, 42, 14, 76]
  let summed = sum(numbers)
  assert summed == 281


proc main() =
  test()
  let input = readFile("input.txt")
  let numbers = toNumbers(input)
  let summed = sum(numbers)
  echo summed


if isMainModule:
  main()
